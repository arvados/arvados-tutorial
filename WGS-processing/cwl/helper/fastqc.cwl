cwlVersion: v1.1
class: CommandLineTool
label: Quality check on FASTQ

requirements:
  DockerRequirement:
    dockerPull: biocontainers/fastqc:v0.11.9_cv6

hints:
  SoftwareRequirement:
    packages:
      FastQC:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_014583" ]
        version: [ "0.11.9" ]

inputs:
  fastq1:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R1)
  fastq2:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R2)

outputs:
  out-html:
    type: File[]
    label: FASTQ QC reports
    format: edam:format_1964 # HTML
    outputBinding:
      glob: "*html"
  out-zip:
    type: File[]
    label: Zip files of FASTQ QC report and associated data
    outputBinding:
      glob: "*fastqc.zip"

baseCommand: fastqc

arguments:
  - $(inputs.fastq1.path)
  - $(inputs.fastq2.path)

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

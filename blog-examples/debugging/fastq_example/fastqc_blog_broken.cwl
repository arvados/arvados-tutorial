cwlVersion: v1.1
class: CommandLineTool
label: Quality check on FASTQ

requirements:
  DockerRequirement:
    dockerPull: biocontainers/fastqc:v0.11.9_cv6

inputs:
  fastq1:
    type: Files 
  fastq2:
    type: File

outputs:
  out-html:
    type: File
    outputBinding:
      glob: "*html"
  out-zip:
    type: File[]
    outputBinding:
      glob: "*fastqc.zip"

baseCommand: fastqc

arguments:
  - $(inputs.fastq1.path)
  - $(inputs.fastq2.path)

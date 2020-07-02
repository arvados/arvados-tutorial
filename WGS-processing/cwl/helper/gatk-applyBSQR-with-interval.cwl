cwlVersion: v1.1
class: CommandLineTool
label: Apply base quality score recalibration 

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
    keep_cache: 1024
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2
  SoftwareRequirement:
    packages:
      GATK:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_001876" ]
        version: [ "4.1.7" ]

inputs:
  bam:
    type: File
    format: edam:format_2572 # BAM
    label: Indexed sorted BAM with labeled duplicates
    secondaryFiles:
      - .bai
  reference:
    type: File
    format: edam:format_1929 # FASTA
    label: Reference genome
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  sample:
    type: string
    label: Sample Name
  recaltable:
    type: File
    label: Recalibration table
  intervallist:
    type: File
    label: Scatter intervals file

outputs:
  recalbam:
    type: File
    format: edam:format_2572 # BAM
    label: Recalibrated BAM for given interval
    secondaryFiles:
      - .bai
    outputBinding:
      glob: "*nodups_BQSR.bam"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - ApplyBQSR
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam.basename)
  - prefix: "--bqsr-recal-file"
    valueFrom: $(inputs.recaltable)
  - prefix: "-L"
    valueFrom: $(inputs.intervallist)
  - prefix: "-O"
    valueFrom: $(inputs.sample)nodups_BQSR.bam

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

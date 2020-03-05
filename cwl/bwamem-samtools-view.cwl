cwlVersion: v1.1
class: CommandLineTool
label: Realigning fastqs and converting output to bam

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 26000
    coresMin: 8

inputs:
  reference:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  fastq1: File
  fastq2: File
  sample: string

stdout: $(inputs.sample).bam

outputs:
  bam:
    type: File
    outputBinding:
      glob: "*bam"

arguments:
  - /bwa-0.7.17/bwa
  - mem
  - -t
  - $(runtime.cores)
  - $(inputs.reference)
  - -R
  - "@RG\\tID:sample\\tSM:sample\\tLB:sample\\tPL:ILLUMINA"
  - $(inputs.fastq1)
  - $(inputs.fastq2)
  - shellQuote: false
    valueFrom: '|'
  - samtools
  - view
  - -b
  - -S
  - shellQuote: false
    valueFrom: '-'

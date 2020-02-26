cwlVersion: v1.1
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 26000
    coresMin: 8

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

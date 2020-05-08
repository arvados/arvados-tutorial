cwlVersion: v1.1
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  fastq1: File
  fastq2: File
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
  sample: string

outputs:
  qc-html:
    type: File[]
    outputSource: fastqc/out-html
  qc-zip:
    type: File[]
    outputSource: fastqc/out-zip 
  vcf:
    type: File
    outputSource: haplotypecaller/vcf

steps:
  fastqc:
    run: fastqc.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
    out: [out-html, out-zip]
  bwamem-samtools-view:
    run: bwamem-samtools-view.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
      reference: reference
      sample: sample
    out: [bam]
  samtools-sort:
    run: samtools-sort.cwl
    in:
      bam: bwamem-samtools-view/bam
      sample: sample
    out: [out]
  samtools-index:
    run: samtools-index.cwl
    in:
      bam: samtools-sort/out
    out: [out]
  haplotypecaller:
    run: gatk-haplotypecaller.cwl
    in:
      reference: reference
      bam: samtools-index/out
      sample: sample
    out: [vcf]

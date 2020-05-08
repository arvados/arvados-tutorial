cwlVersion: v1.1
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    secondaryFiles:
      - .bai
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
  knownsites1:
    type: File
    secondaryFiles:
      - .tbi
  intervallist:
    type: File

outputs:
  gvcf:
    type: File
    outputSource: haplotypecaller/gvcf

steps:
  basecalibrator:
    run: gatk-baserecalibrator-with-interval.cwl
    in:
      bam: bam
      reference: reference
      sample: sample
      knownsites1: knownsites1
      intervallist: intervallist
    out: [recaltable]
  applyBQSR:
    run: gatk-applyBSQR-with-interval.cwl
    in: 
      reference: reference
      bam: bam
      sample: sample
      intervallist: intervallist
      recaltable: basecalibrator/recaltable
    out: [recalbam]
  haplotypecaller:
    run: gatk-haplotypecaller-with-interval.cwl
    in:
      reference: reference
      bam: applyBQSR/recalbam
      sample: sample
      intervallist: intervallist
    out: [gvcf]

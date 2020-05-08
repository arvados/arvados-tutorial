$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"
cwlVersion: v1.1
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

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
  scattercount: string

outputs:
  gvcf:
    type: File[]
    outputSource: recal-haplotypecaller/gvcf

steps:
  splitintervals:
    run: gatk-splitintervals.cwl
    in:
      reference: reference
      sample: sample
      scattercount: scattercount
    out: [intervalfiles]
      
  recal-haplotypecaller: 
    run: gatk-wf-with-interval.cwl
    scatter: intervallist
    in:
      bam: bam
      reference: reference
      sample: sample
      knownsites1: knownsites1
      intervallist: splitintervals/intervalfiles
    out: [gvcf]

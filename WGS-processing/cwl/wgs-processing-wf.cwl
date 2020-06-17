Version: v1.1
class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  fastqdir: Directory 
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
  knownsites:
    type: File
    secondaryFiles:
      - .tbi   
  scattercount: string
  clinvarvcf: File
  reportfunc: File
  headhtml: File
  tailhtml: File

outputs:
  gvcf:
    type: File[]
    outputSource: bwamem-gatk-report/gvcf
  report:
    type: File[]  
    outputSource: bwamem-gatk-report/report

steps:
  getfastq:
    run: ./helper/getfastq.cwl
    in:
      fastqdir: fastqdir
    out: [fastq1, fastq2]

  bwamem-gatk-report:
    run: ./helper/bwamem-gatk-report-wf.cwl
    scatter: [fastq1, fastq2]
    scatterMethod: dotproduct
    in:
      fastq1: getfastq/fastq1
      fastq2: getfastq/fastq2
      reference: reference
      sample: sample
      knownsites: knownsites
      scattercount: scattercount
      clinvarvcf: clinvarvcf
      reportfunc: reportfunc
      headhtml: headhtml
      tailhtml: tailhtml
    out: [qc-html,qc-zip,gvcf,report]
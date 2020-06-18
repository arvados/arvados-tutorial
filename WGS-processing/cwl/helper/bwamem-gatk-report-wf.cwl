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
  qc-html:
    type: File[]
    outputSource: fastqc/out-html
  qc-zip:
    type: File[]
    outputSource: fastqc/out-zip 
  gvcf:
    type: File
    outputSource: haplotypecaller/gatheredgvcf
  report:
    type: File  
    outputSource: generate-report/report
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
    out: [sortedbam]
  mark-duplicates:
    run: mark-duplicates.cwl
    in:
      bam: samtools-sort/sortedbam
    out: [dupbam,dupmetrics]
  samtools-index:
    run: samtools-index.cwl
    in:
      bam: mark-duplicates/dupbam
    out: [indexedbam]
  haplotypecaller:
    run: scatter-gatk-wf-with-interval.cwl 
    in:
      reference: reference
      bam: samtools-index/indexedbam
      sample: sample
      scattercount: scattercount
      knownsites1: knownsites
    out: [gatheredgvcf]
  generate-report:
    run: report-wf.cwl
    in:
      gvcf: haplotypecaller/gatheredgvcf
      samplename: sample
      clinvarvcf: clinvarvcf
      reportfunc: reportfunc
      headhtml: headhtml
      tailhtml: tailhtml
    out: [report] 

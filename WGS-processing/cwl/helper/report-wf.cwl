cwlVersion: v1.1
class: Workflow

inputs:
  gvcf: 
    type: File
  samplename:
    type: string
  clinvarvcf:
    type: File
  reportfunc:
    type: File
  headhtml:
    type: File
  tailhtml:   
    type: File

outputs:
  report:
    type: File
    outputSource: generate-report/report

steps:
  gvcf-to-vcf:
    run: ./helper/gvcf-to-vcf.cwl
    in:
      gvcf: gvcf
      samplename: samplename
    out: [vcf]

  annotate:
    run: ./helper/annotate-vcf.cwl
    in:
      vcf: gvcf-to-vcf/vcf
      clinvarvcf: clinvarvcf
    out: [reporttxt]

  generate-report:
    run: ./helper/generate-report.cwl
    in:
      reportfunc: reportfunc
      sampletxt: annotate/reporttxt
      headhtml: headhtml
      tailhtml: tailhtml
    out: [report]
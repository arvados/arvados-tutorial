cwlVersion: v1.1
class: Workflow

inputs:
  vcf: 
    type: File
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
  annotate:
    run: annotate-vcf.cwl
    in:
      vcf: vcf
      clinvarvcf: clinvarvcf
    out: [reporttxt]

  generate-report:
    run: generate-report.cwl
    in:
      reportfunc: reportfunc
      sampletxt: annotate/reporttxt
      headhtml: headhtml
      tailhtml: tailhtml
    out: [report]

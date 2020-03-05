cwlVersion: v1.1
class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: curii/clinvar-report
  - class: ShellCommandRequirement

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

stdout: $(inputs.vcf.nameroot).txt

arguments:
  - bcftools
  - annotate
  - prefix: "-a"
    valueFrom: $(inputs.clinvarvcf.path)
  - prefix: "-c"
    valueFrom: "ID,INFO"
  - $(inputs.vcf.path)
  - {valueFrom: '|', shellQuote: false}
  - bcftools
  - filter
  - prefix: "-i"
    valueFrom: "INFO/ALLELEID>=1"

inputs: 
  vcf:
    type: File
  clinvarvcf:
    type: File
  
outputs:
  report: stdout

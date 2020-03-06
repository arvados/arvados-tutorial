cwlVersion: v1.1
class: CommandLineTool
label: Converts gvcf to vcf

requirements:
  - class: DockerRequirement
    dockerPull: curii/clinvar-report
  - class: ShellCommandRequirement

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

inputs:
  samplename:
    type: string
  gvcf:
    type: File
  
outputs:
  vcf:
    type: File
    outputBinding:
      glob: "*.vcf.gz"
    secondaryFiles: [.tbi]

arguments:
  - bcftools
  - view 
  - prefix: "--min-ac"
    valueFrom: "1"
  - $(inputs.gvcf.path)
  - valueFrom: "-Ov"
  - prefix: "-o"
    valueFrom: $(inputs.samplename).vcf
  - {valueFrom: '&&', shellQuote: false}
  - bgzip
  - valueFrom: $(inputs.samplename).vcf
  - {valueFrom: '&&', shellQuote: false}
  - tabix
  - valueFrom: $(inputs.samplename).vcf.gz

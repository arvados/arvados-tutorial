cwlVersion: v1.1
class: CommandLineTool
label: Germline variant calling using GATK with output gvcf

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    

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

outputs:
  gvcf:
    type: File
    outputBinding:
      glob: "*vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - HaplotypeCaller
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam)
  - prefix: "-O"
    valueFrom: $(runtime.outdir)/$(inputs.sample).gatk.g.vcf.gz
  - prefix: "-ERC"
    valueFrom: "GVCF"
  - prefix: "-GQB"
    valueFrom: "5"
  - prefix: "-GQB"
    valueFrom: "20"
  - prefix: "-GQB"
    valueFrom: "60"

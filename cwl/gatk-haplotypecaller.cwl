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
    ramMin: 10000
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

arguments:
  - java
  - -jar
  - /gatk/gatk.jar
  - HaplotypeCaller
  - -R
  - $(inputs.reference)
  - -I
  - $(inputs.bam)
  - -O
  - $(runtime.outdir)/$(inputs.sample).gatk.g.vcf.gz
  - -ERC
  - "GVCF"

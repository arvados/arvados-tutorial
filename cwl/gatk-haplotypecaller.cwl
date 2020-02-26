cwlVersion: v1.1
class: CommandLineTool

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
  - $(runtime.outdir)/$(inputs.sample).gatk.vcf

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
  vcf:
    type: File
    outputBinding:
      glob: "*vcf"

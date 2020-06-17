cwlVersion: v1.1
class: CommandLineTool
label: Validate Sam using Picard 

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk
  InitialWorkDirRequirement:
    listing:
      - $(inputs.sam)

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    

inputs:
  sam:
    type: File

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

outputs:
  metrics:
    type: File
    outputBinding:
      glob: "*.txt"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - ValidateSamFile 
  - prefix: "-I"
    valueFrom: $(inputs.sam.basename)
  - prefix: "-M"
    valueFrom: "SUMMARY"
  - prefix: "-O"
    valueFrom: "metrics.txt" 
  - prefix: "-R"
    valueFrom: $(inputs.reference.path)

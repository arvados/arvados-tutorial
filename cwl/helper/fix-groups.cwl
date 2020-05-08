cwlVersion: v1.1
class: CommandLineTool
label: Marking Duplicates using Picard 

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    

inputs:
  bam:
    type: File

outputs:
  fixedrgbam:
    type: File
    outputBinding:
      glob: "*.bam"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - AddOrReplaceReadGroups 
  - prefix: "-I"
    valueFrom: $(inputs.bam.path)
  - prefix: "-O"
    valueFrom: fixedrg$(inputs.bam.basename)
  - prefix: "-ID"
    valueFrom: "H0164.2"
  - prefix: "-LB"
    valueFrom: "library1"
  - prefix: "-PL"
    valueFrom: "illumina"
  - prefix: "-PU"
    valueFrom: "H0164ALXX140820.2"
  - prefix: "-SM"
    valueFrom: "sample1"

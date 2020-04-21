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
  dupbam:
    type: File
    outputBinding:
      glob: "*.bam"
  dupmetrics:
    type: File
    outputBinding:
      glob: "*.txt"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - MarkDuplicates
  - prefix: "-I"
    valueFrom: $(inputs.bam.path)
  - prefix: "-O"
    valueFrom: marked_dups$(inputs.bam.basename)
  - prefix: "-M"
    valueFrom: "metrics.txt" 

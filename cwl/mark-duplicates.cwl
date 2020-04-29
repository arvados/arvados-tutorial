cwlVersion: v1.1
class: CommandLineTool
label: Marking Duplicates using Picard 
$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

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

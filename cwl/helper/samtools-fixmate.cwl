cwlVersion: v1.1
class: CommandLineTool

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

inputs:
  bam: File
  sample: string

outputs:
  out:
    type: File
    outputBinding:
      glob: "*fixed.bam"

baseCommand: samtools

arguments:
  - fixmate 
  - -O
  - "bam"
  - $(inputs.bam.path)
  - $(runtime.outdir)/$(inputs.sample).fixed.bam

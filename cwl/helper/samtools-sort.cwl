cwlVersion: v1.1
class: CommandLineTool
label: Sorting Bam file

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4

hints:
  arv:RuntimeConstraints:
    keep_cache: 9216 
    outputDirType: keep_output_dir

inputs:
  bam: File
  sample: string

outputs:
  sortedbam:
    type: File
    outputBinding:
      glob: "*sorted.bam"

baseCommand: samtools

arguments:
  - sort
  - -@
  - $(runtime.cores)
  - $(inputs.bam.path)
  - -m
  - '2G'
  - -o
  - $(inputs.sample).sorted.bam

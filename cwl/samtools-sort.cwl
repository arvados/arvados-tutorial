cwlVersion: v1.1
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

inputs:
  bam: File
  sample: string

outputs:
  out:
    type: File
    outputBinding:
      glob: "*sorted.bam

runcommand: samtools

arguments:
  - sort
  - -t
  - $(runtime.cores)
  - $(inputs.bam)
  - -o
  - $(runtime.outdir)/$(inputs.sample).sorted.bam

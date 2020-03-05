cwlVersion: v1.1
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

inputs:
  bam: File

outputs:
  out:
    type: File
    outputBinding:
      glob: "*bam"
    secondaryFiles:
      - .bai

runcommand: samtools

arguments:
  - index
  - $(inputs.bam.basename)

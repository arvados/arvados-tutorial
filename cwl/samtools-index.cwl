cwlVersion: v1.1
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

arguments:
  - samtools
  - index
  - $(inputs.bam.basename)

inputs:
  bam: File

outputs:
  out:
    type: File
    outputBinding:
      glob: "*bam"
    secondaryFiles:
      - .bai


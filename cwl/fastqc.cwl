cwlVersion: v1.1
class: CommandLineTool

requirements:
  DockerRequirement:
    dockerPull: curii/fastqc
  InitialWorkDirRequirement:
    listing:
      - $(inputs.fastq1)
      - $(inputs.fastq2)

arguments:
  - perl
  - /FastQC/fastqc
  - $(inputs.fastq1.basename)
  - $(inputs.fastq2.basename)

inputs:
  fastq1: File
  fastq2: File

outputs:
  out-html:
    type: File[]
    outputBinding:
      glob: "*html"
  out-zip:
    type: File[]
    outputBinding:
      glob: "*fastqc.zip"

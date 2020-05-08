cwlVersion: v1.1
class: CommandLineTool
label: Quality check on fastq data using FastQC

requirements:
  DockerRequirement:
    dockerPull: curii/fastqc
  InitialWorkDirRequirement:
    listing:
      - $(inputs.fastq1)
      - $(inputs.fastq2)

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

baseCommand: perl
arguments:
  - /FastQC/fastqc
  - $(inputs.fastq1.basename)
  - $(inputs.fastq2.basename)

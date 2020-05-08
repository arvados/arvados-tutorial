cwlVersion: v1.1
class: CommandLineTool
label: Indexing Bam File

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

inputs:
  bam: File

outputs:
  bam:
    type: File
    outputBinding:
      glob: "*bam"
    secondaryFiles:
      - .bai

baseCommand: samtools

arguments:
  - index
  - $(inputs.bam.basename)

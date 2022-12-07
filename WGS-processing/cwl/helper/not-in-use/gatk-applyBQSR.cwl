cwlVersion: v1.1
class: CommandLineTool
label: Applying base quality score recalibration

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
#    keep_cache: 1024
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2

inputs:
  bam:
    type: File
  reference:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  sample: string
  recaltable:
    type: File

outputs:
  recalbam:
    type: File
    outputBinding:
      glob: "*nodups_BQSR.bam"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - ApplyBQSR
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam.basename)
  - prefix: "--bqsr-recal-file"
    valueFrom: $(inputs.recaltable)
  - prefix: "-O"
    valueFrom: $(inputs.sample)nodups_BQSR.bam

cwlVersion: v1.1
class: CommandLineTool
label: Generating recalibration table for BQSR 

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
    keep_cache: 1024
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
  knownsites1: 
    type: File
    secondaryFiles:
      - .tbi

outputs:
  recaltable:
    type: File
    outputBinding:
      glob: "*.table"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - BaseRecalibrator
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam.basename)
  - prefix: "--known-sites"
    valueFrom: $(inputs.knownsites1)
  - prefix: "-O"
    valueFrom: $(inputs.sample)_recal_data.table

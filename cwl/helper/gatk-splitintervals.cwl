cwlVersion: v1.1
class: CommandLineTool
label: Creating interval files for scattering

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
    keep_cache: 1024
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2

inputs:
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
  scattercount: string
 
outputs:
  intervalfiles:
    type: File[]
    outputBinding:
      glob: "intervalfiles/*.interval_list"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - SplitIntervals
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "--scatter-count"
    valueFrom: $(inputs.scattercount)
  - prefix: "--subdivision-mode"
    valueFrom: "BALANCING_WITHOUT_INTERVAL_SUBDIVISION"
  - prefix: "-O"
    valueFrom: "intervalfiles"

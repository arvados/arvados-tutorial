cwlVersion: v1.1
class: CommandLineTool

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
  gvcf:
    type: File
    secondaryFiles:
      - .tbi
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

outputs:
  filteredgvcf:
    type: File
    outputBinding:
      glob: "*g.vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - SelectVariants 
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "--remove-unused-alternates"
    valueFrom: "true"
  - prefix: "-V"
    valueFrom: $(inputs.gvcf.path)
  - prefix: "-O"
    valueFrom: selected$(inputs.gvcf.basename)

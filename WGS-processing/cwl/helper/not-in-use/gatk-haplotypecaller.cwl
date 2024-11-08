cwlVersion: v1.1
class: CommandLineTool
label: Germline variant calling using GATK with output gvcf

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
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2

inputs:
  bam:
    type: File
    secondaryFiles:
      - .bai
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
  gvcf:
    type: File
    outputBinding:
      glob: "*vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - HaplotypeCaller
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam)
  - prefix: "-O"
    valueFrom: $(runtime.outdir)/$(inputs.sample).gatk.g.vcf.gz
  - prefix: "-ERC"
    valueFrom: "GVCF"
  - prefix: "-GQB"
    valueFrom: "5"
  - prefix: "-GQB"
    valueFrom: "20"
  - prefix: "-GQB"
    valueFrom: "60"

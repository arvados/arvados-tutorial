cwlVersion: v1.1
class: CommandLineTool
label: Gathering vcf using Picard 
$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0
  ShellCommandRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.gvcf1)
      - $(inputs.gvcf2)

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

inputs:
  gvcf1:
    type: File
  gvcf2:
    type: File
  sample: string
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
outputs:
  gatheredgvcf:
    type: File
    outputBinding:
      glob: "*g.vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - MergeVcfs
  - prefix: "-I"
    valueFrom: $(inputs.gvcf1.basename) 
  - prefix: "-I"
    valueFrom: $(inputs.gvcf2.basename)
  - prefix: "-O"
    valueFrom: $(inputs.sample)g.vcf.gz

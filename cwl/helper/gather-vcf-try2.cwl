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
  InlineJavascriptRequirement: {}

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

inputs:
  gvcfarray: File[]
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
      glob: "*.g.vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - GatherVcfs
  - shellQuote: false
    valueFrom: >
      ${
        var cmd "";
        for( var i = 0; i < inputs.gvcfarray.length; i++){
           cmd += "\s echo " + "-I" + "\s" + inputs.gvcfsarray[i]
        }
        return cmd;
       } 
  - prefix: "-O"
    valueFrom: $(inputs.sample).g.vcf.gz

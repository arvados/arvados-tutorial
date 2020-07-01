cwlVersion: v1.1
class: CommandLineTool
label: Gather GVCFs
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
  gvcfarray: 
    type: File[] 
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
    secondaryFiles:
      - .tbi
    outputBinding:
      glob: "*.g.vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - MergeVcfs
  - shellQuote: false
    valueFrom: | 
     ${function compare(a, b) {
      var baseA = a.basename;
      var baseB = b.basename;

      var comparison = 0;
      if (baseA > baseB) {
      comparison = 1;
      } else if (baseA < baseB) {
      comparison = -1;
      }
      return comparison;
      }

      var sortedarray = [];
      sortedarray = inputs.gvcfarray.sort(compare)
 
      var samples = [];
      for (var i = 0; i < sortedarray.length; i++) {
        var name = sortedarray[i];
        if (name.nameext ==='.gz' ) {
          samples.push(name.path);
        }
      }
     
      var sampleinput = "";

      for (var i = 0; i < samples.length; i++) {
       var s1 = samples[i];
       sampleinput = sampleinput + "-I " + s1 + " "
      }
    
      return sampleinput;
      }
  - prefix: "-O"
    valueFrom: $(inputs.sample).g.vcf.gz

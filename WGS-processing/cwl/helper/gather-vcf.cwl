cwlVersion: v1.1
class: CommandLineTool
label: Gather GVCF using Picard 

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
  gvcfdir:
    type: Directory
    label: Input directory of GVCFs
    loadListing: 'shallow_listing'
  sample:
    type: string
    label: Sample Name
  reference:
    type: File
    format: edam:format_1929 # FASTA
    label: Reference genome
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
    format: edam:format_3016 # GVCF
    label: Gathered GVCF
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

      var samples = [];
      for (var i = 0; i < inputs.gvcfdir.listing.length; i++) {
        var name = inputs.gvcfdir.listing[i];
        if (name.nameext ==='.gz' ) {
          samples.push(name.path);
        }
      }
      samples = samples.sort(compare);
      var sampleinput = [];

      for (var i = 0; i < samples.length; i++) {
       var s1 = samples[i];
       sampleinput = sampleinput + "-I " + s1 + " "
      }
    
      return sampleinput;
      }
  - prefix: "-O"
    valueFrom: $(inputs.sample).g.vcf.gz

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

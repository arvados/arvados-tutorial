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
  gvcfdir: 
    type: Directory
    label: Input directory of gvcfs
    loadListing: 'shallow_listing'
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
    var samples = [];
    for (var i = 0; i < inputs.gvcfdir.listing.length; i++) {
      var name = inputs.gvcfdir.listing[i];
      if (name.nameext ==='.gz' ) {
        samples.push(name.basename);
      }
    }
    samples = samples.sort();
    var sampleinput = [];

    for (var i = 0; i < samples.length; i++) {
     var s1 = samples[i];
     sampleinput = sampleinput + "-I " + s1 + " "
    }
    return sampleinput;
    }
  - prefix: "-O"
    valueFrom: $(inputs.sample).g.vcf.gz

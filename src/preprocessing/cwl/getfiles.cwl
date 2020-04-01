$namespaces:
  cwltool: "http://commonwl.org/cwltool#"
class: ExpressionTool
label: Create list of bams from directory
cwlVersion: v1.1
requirements:
  InlineJavascriptRequirement: {}

inputs:
  bamdir:
    type: Directory
    label: Directory of input bams
    loadListing: shallow_listing
 
outputs:
  tarzipbams:
    type: File[]
    label: Array of bams 
  samplenames:
    type: string[]
    label: Array of sample names

expression: |
  ${
    var tarzipbams = [];
    var samplenames = [];

    for (var i = 0; i < inputs.bamdir.listing.length; i++) {
      var file = inputs.bamdir.listing[i];
      if (file.nameext == '.tgz') {
        var main = file;
        var sample = file.nameroot;
        sample = sample.replace(".bam","")
        tarzipbams.push(main);
        samplenames.push(sample);
      }
    }
    return {"tarzipbams": tarzipbams, "samplenames": samplenames};
  }


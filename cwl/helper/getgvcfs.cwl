$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"
class: ExpressionTool
cwlVersion: v1.1
label: Create array of gvcfs to process
requirements:
  InlineJavascriptRequirement: {}
inputs:
  gvcfdir:
    type: Directory
    label: Input directory of gvcfs
    loadListing: 'shallow_listing' 
outputs:
  sampleinput: 
    type: string
expression: |
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


    return {"sampleinput": sampleinput};

  }

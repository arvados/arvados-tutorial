$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"
class: ExpressionTool
cwlVersion: v1.1
label: Create array of gvcfs to process
requirements:
  InlineJavascriptRequirement: {}
inputs:
  fastjdir:
    type: Directory
    label: Input directory of fastj
    loadListing: 'shallow_listing' 
outputs:
  fastq1: 
    type: File[]
  fastq2:
    type: File[]
expression: |
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

    var fastq1 = [];
    var fastq2 = [];
    for (var i = 0; i < inputs.fastjdir.listing.length; i++) {
      var name = inputs.fastjdir.listing[i];
      if (name.basename.indexOf('_1.fastq.gz') != -1 ) {
        fastq1.push(name);
      }
      if (name.basename.indexOf('_2.fastq.gz') != -1 ) {
        fastq2.push(name);
      }
    }
  
    fastq1 = fastq1.sort(compare)
    fastq2 = fastq2.sort(compare)
 
    return {"fastq1": fastq1, "fastq2": fastq2};
  }

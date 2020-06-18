$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"
class: ExpressionTool
cwlVersion: v1.1
label: Create array of gvcfs to process
requirements:
  InlineJavascriptRequirement: {}
inputs:
  fastqdir:
    type: Directory
    label: Input directory of fastqs
    loadListing: 'shallow_listing' 
outputs:
  fastq1: 
    type: File[]
  fastq2:
    type: File[]
  sample:
    type: string[]
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
    for (var i = 0; i < inputs.fastqdir.listing.length; i++) {
      var name = inputs.fastqdir.listing[i];
      if (name.basename.indexOf('_1.fastq.gz') != -1 ) {
        fastq1.push(name);
      }
      if (name.basename.indexOf('_2.fastq.gz') != -1 ) {
        fastq2.push(name);
      }
    }
  
    fastq1 = fastq1.sort(compare)
    fastq2 = fastq2.sort(compare)

    var sample = [];

    for (var i = 0; i < fastq1.length; i++) {
      var name = fastq1[i].basename;
      var samplename = name.replace(/_1.fastq.gz/,'');
      sample.push(samplename);
      }

 
    return {"fastq1": fastq1, "fastq2": fastq2, "sample": sample};
  }

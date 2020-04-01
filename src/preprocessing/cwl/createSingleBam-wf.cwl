cwlVersion: v1.1
class: Workflow 
$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  ScatterFeatureRequirement: {}

inputs:
  bamdir:
    type: Directory 
    label: Directory of zipped bam files

outputs:
  fastqs:
    type: 
      type: array
      items:
        type: array
        items: File 
    outputSource: convert-bams/fastqs

steps:
  get-bams:
    run: getfiles.cwl
    in:
      bamdir: bamdir
    out: [tarzipbams,samplenames]

  convert-bams:
    run: createSingleBam.cwl
    scatter: [tarzipbam,samplename]
    scatterMethod: dotproduct
    in:
      tarzipbam: get-bams/tarzipbams
      samplename: get-bams/samplenames
    out: [fastqs]

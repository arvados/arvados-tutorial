cwlVersion: v1.2
class: Workflow
label: RNAseq workflow 

inputs:
  fqdir: 
    type: Directory 
    loadListing: shallow_listing
  genome: Directory
  gtf: File

steps:
  alignment:
    run: helper/alignment.cwl
    scatter: fq
    in:
      fq:
        valueFrom: $(inputs.fqdir.listing)
      genome: genome
      gtf: gtf
    out: [qc_html, bam_sorted_indexed]

  featureCounts:
    requirements:
      ResourceRequirement:
        ramMin: 500
    run: helper/featureCounts.cwl
    in:
      counts_input_bam: alignment/bam_sorted_indexed
      gtf: gtf
    out: [featurecounts]

  output-subdirs:
    run: helper/subdirs.cwl
    in:
      fq: 
       valueFrom: $(inputs.fqdir.listing)
      bams: alignment/bam_sorted_indexed
      qc: alignment/qc_html
    out: [dirs]

outputs:
  dirs:
    type: Directory[]
    outputSource: output-subdirs/dirs

  featurecounts:
    type: File
    outputSource: featureCounts/featurecounts

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  StepInputExpressionRequirement: {}

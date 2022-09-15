cwlVersion: v1.2
class: Workflow
label: RNAseq CWL practice workflow

inputs:
  fq: File
  genome: Directory
  gtf: File

requirements:
  StepInputExpressionRequirement: {}

steps:
  fastqc:
    run: fastqc_2.cwl
    in:
      reads_file: fq
    out: [html_file]

  STAR:
    requirements:
      ResourceRequirement:
        ramMin: 9000
    run: STAR-Align.cwl
    in:
      RunThreadN: {default: 4}
      GenomeDir: genome
      ForwardReads: fq
      OutSAMtype: {default: BAM}
      SortedByCoordinate: {default: true}
      OutSAMunmapped: {default: Within}
      OutFileNamePrefix: {valueFrom: "$(inputs.ForwardReads.nameroot)."}
    out: [alignment]

  samtools:
    run: samtools_index.cwl
    in:
      bam_sorted: STAR/alignment
    out: [bam_sorted_indexed]

outputs:
  qc_html:
    type: File
    outputSource: fastqc/html_file
  bam_sorted_indexed:
    type: File
    outputSource: samtools/bam_sorted_indexed

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html
cwlVersion: v1.1
class: Workflow
label: Scatter to convert one chromosome of bam to fastqs
requirements:
  ScatterFeatureRequirement: {}

inputs:
  bams:
    type:
      type: array
      items: File
    format: edam:format_2572 # BAM
    secondaryFiles: [.bai]
    label: Alignments in BAM format
  samples:
    type:
      type: array
      items: string
    label: Sample names
  chrom:
    type: string
    label: Chromosome name

outputs:
  fastq1s:
    type:
      type: array
      items: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R1)
    outputSource: bam2singlechromfastq/fastq1
  fastq2s:
    type:
      type: array
      items: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R2)
    outputSource: bam2singlechromfastq/fastq2

steps:
  bam2singlechromfastq:
    run: bam2singlechromfastq.cwl
    scatter: [bam, sample]
    scatterMethod: dotproduct
    in:
      bam: bams
      sample: samples
      chrom: chrom
    out: [fastq1, fastq2]

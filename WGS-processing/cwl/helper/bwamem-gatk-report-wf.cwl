cwlVersion: v1.1
class: Workflow
label: WGS processing workflow for single sample

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  fastq1:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R1)
  fastq2:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R2)
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
  sample: 
    type: string
    label: Sample Name
  knownsites:
    type: File
    format: edam:format_3016 # VCF
    label: VCF of known polymorphic sites for BQSR
    secondaryFiles:
      - .tbi   
  scattercount: 
    type: string
    label: Desired split for variant calling
  clinvarvcf:
    type: File
    format: edam:format_3016 # VCF
    label: Reference VCF for ClinVar
  reportfunc:
    type: File
    label: Function used to create HTML report
  headhtml:
    type: File
    format: edam:format_1964 # HTML
    label: Header for HTML report
  tailhtml:
    type: File
    format: edam:format_1964 # HTML
    label: Footer for HTML report

outputs:
  qc-html:
    type: File[]
    label: FASTQ QC reports
    format: edam:format_1964 # HTML
    outputSource: fastqc/out-html
  qc-zip:
    type: File[]
    label: Zip files of FASTQ QC report and associated data
    outputSource: fastqc/out-zip 
  gvcf:
    type: File
    outputSource: haplotypecaller/gatheredgvcf
    format: edam:format_3016 # GVCF
    label: GVCF generated from GATK Haplotype Caller
  report:
    type: File  
    outputSource: generate-report/report
    format: edam:format_1964 # HTML
    label: ClinVar variant report

steps:
  fastqc:
    run: fastqc.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
    out: [out-html, out-zip]
  bwamem-samtools-view:
    run: bwamem-samtools-view.cwl
    in:
      fastq1: fastq1
      fastq2: fastq2
      reference: reference
      sample: sample
    out: [bam]
  samtools-sort:
    run: samtools-sort.cwl
    in:
      bam: bwamem-samtools-view/bam
      sample: sample
    out: [sortedbam]
  mark-duplicates:
    run: mark-duplicates.cwl
    in:
      bam: samtools-sort/sortedbam
    out: [dupbam,dupmetrics]
  samtools-index:
    run: samtools-index.cwl
    in:
      bam: mark-duplicates/dupbam
    out: [indexedbam]
  haplotypecaller:
    run: scatter-gatk-wf-with-interval.cwl 
    in:
      reference: reference
      bam: samtools-index/indexedbam
      sample: sample
      scattercount: scattercount
      knownsites: knownsites
    out: [gatheredgvcf]
  generate-report:
    run: report-wf.cwl
    in:
      gvcf: haplotypecaller/gatheredgvcf
      samplename: sample
      clinvarvcf: clinvarvcf
      reportfunc: reportfunc
      headhtml: headhtml
      tailhtml: tailhtml
    out: [report]

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

$schemas:
 - https://schema.org/version/latest/schema.rdf
 - http://edamontology.org/EDAM_1.18.owl

cwlVersion: v1.1
class: Workflow
label: Whole Genome Sequence processing workflow scattered over samples
doc: |
  <p>This is a “real-world” workflow example for processing Next
  Generation Sequencing (NGS) Whole Genome Sequence (WGS) data.</p>

  <p>You can learn more and run this workflow yourself by going
  through the <a
  href="https://doc.arvados.org/main/user/tutorials/wgs-tutorial.html">Processing
  Whole Genome Sequences</a> walkthrough in the Arvados user
  guide.</p>

  <p>The steps of this workflow include:</p>

  <ol>
  <li>Check of fastq quality using FastQC</li>
  <li>Local alignment using BWA-MEM</li>
  <li>Variant calling in parallel using GATK Haplotype Caller</li>
  <li>Generation of an HTML report comparing variants against ClinVar archive</li>
  </ol>

  <p>The primary input parameter is the <b>Directory of paired FASTQ
  files</b>, which should contain paired FASTQ files (suffixed with _1
  and _2) to be processed.  The workflow scatters over the samples to
  process them in parallel.</p>

  <p>The remaining parameters are reference data used by various tools
  in the pipeline.</p>

requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
  fastqdir:
    type: Directory
    label: Directory of paired FASTQ files
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
  fullintervallist:
    type: File
  knownsites1:
    type: File
    format: edam:format_3016 # VCF
    label: VCF of known SNPS sites for BQSR
    secondaryFiles:
      - .idx
  knownsites2:
    type: File
    format: edam:format_3016 # VCF
    label: VCF of known indel sites for BQSR
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
    format: edam:format_2331 # HTML
    label: Header for HTML report
  tailhtml:
    type: File
    format: edam:format_2331 # HTML
    label: Footer for HTML report

outputs:
  gvcf:
    type: File[]
    outputSource: bwamem-gatk-report/gvcf
    format: edam:format_3016 # GVCF
    label: GVCFs generated from GATK
  report:
    type: File[]
    outputSource: bwamem-gatk-report/report
    format: edam:format_2331 # HTML
    label: ClinVar variant reports
  qcreport:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: bwamem-gatk-report/qc-html
    format: edam:format_2331 # HTML
    label: FASTQ quality reports produced by fastqc

steps:
  getfastq:
    run: ./helper/getfastq.cwl
    in:
      fastqdir: fastqdir
    out: [fastq1, fastq2, sample]

  bwamem-gatk-report:
    run: ./helper/bwamem-gatk-report-wf.cwl
    scatter: [fastq1, fastq2, sample]
    scatterMethod: dotproduct
    in:
      fastq1: getfastq/fastq1
      fastq2: getfastq/fastq2
      reference: reference
      fullintervallist: fullintervallist
      sample: getfastq/sample
      knownsites1: knownsites1
      knownsites2: knownsites2
      scattercount: scattercount
      clinvarvcf: clinvarvcf
      reportfunc: reportfunc
      headhtml: headhtml
      tailhtml: tailhtml
    out: [qc-html,qc-zip,gvcf,report]

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

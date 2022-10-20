cwlVersion: v1.1
class: Workflow
label: WGS processing workflow scattered over samples


requirements:
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - {$import: sample-metadata.yml}

hints:
  arv:OutputCollectionProperties:
    outputProperties:
      metadata_columns: [["Sample_ID", "Date", "RunName", "InstrumentPlatform"]]
      metadata_rows: |
        ${
         var md = [];
         if (inputs.metadata) {
           for (var m of inputs.metadata) {
             var item = [];
             for (const property of ["Sample_ID", "Date", "RunName", "InstrumentPlatform"]) {
               item.push(m[property]);
             }
             md.push(item);
           }
           return md;
        } else { return []; }
        }

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
  metadata:
    type:
      type: array
      items: "sample-metadata.yml#SampleMetadata"
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
 arv: "http://arvados.org/cwl#"

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

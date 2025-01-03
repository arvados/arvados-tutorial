cwlVersion: v1.1
class: Workflow
label: Report generation workflow

inputs:
  gvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: Gathered GVCF
  sample:
    type: string
    label: Sample Name
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

  promptprefix:
    type: File
    default:
      class: File
      contents: "The following is a genome variant report."

  questions:
    type: File
    default:
      class: File
      contents: |
        Please answer the following questions about the genome variant report.

        1. What is the most important variant in this genome?

        2. Does this variant start to impact participants at birth or later in life?

        3. Are there pharmacogenetic variants that are important?

        Write your answers here:

  llamafile:
    type: 'llm/llamafile-schema.yml#LlamaFile'
    default: {$import: "llm/mistral.yml"}

outputs:
  report:
    type: File
    format: edam:format_2331 # HTML
    label: ClinVar variant report
    outputSource: generate-report/report
  llmreport:
    type: File
    label: AI analysis of variants based on ClinVar and MedGen
    outputSource: llm-summarize/responses

steps:
  gvcf-to-vcf:
    run: gvcf-to-vcf.cwl
    in:
      gvcf: gvcf
      sample: sample
    out: [vcf]
  annotate:
    run: annotate-vcf.cwl
    in:
      vcf: gvcf-to-vcf/vcf
      clinvarvcf: clinvarvcf
    out: [reporttxt]
  generate-report:
    run: generate-report.cwl
    in:
      reportfunc: reportfunc
      sampletxt: annotate/reporttxt
      sample: sample
      headhtml: headhtml
      tailhtml: tailhtml
    out: [report]
  medgen-report:
    run: llm/generate-report.cwl
    in:
      sampletxt: annotate/reporttxt
      sample: sample
    out: [report]

  llm-summarize:
    run: llm/summarize-report.cwl
    in:
      promptprefix: promptprefix
      reportfile: medgen-report/report
      questions: questions
      context: $(25000)
    out: [responses]

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

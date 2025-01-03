cwlVersion: v1.2
class: Workflow

#$namespaces:
#  l: 'llamafile-schema.yml#'

inputs:
  promptprefix: File?
  report: File
  questions: File?
  context: int?

  llamafile: 'llamafile-schema.yml#LlamaFile'

requirements:
  StepInputExpressionRequirement: {}
  InlineJavascriptRequirement: {}
  ScatterFeatureRequirement: {}
  SchemaDefRequirement:
    types:
      - {$import: llamafile-schema.yml}

steps:
  make-prompt:
    in:
      promptprefix: promptprefix
      reportfile: report
      questions: questions
    run: construct-prompt.cwl
    out: [text]

  ai-report-summary:
    in:
      llamafile: llamafile
      promptfile: make-prompt/text
      context: context
    run: llamafile.cwl
    out: [response]

outputs:
  responses:
    type: File
    outputSource: ai-report-summary/response

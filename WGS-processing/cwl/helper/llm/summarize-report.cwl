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
  makePrompt:
    in:
      promptprefix: promptprefix
      reportfile: report
      questions: questions
    run: construct-prompt.cwl
    out: [text]

  response:
    in:
      llamafile: llamafile
      promptfile: makePrompt/text
      context: context
    scatter: scaleout
    run: llamafile.cwl
    out: [response]

outputs:
  responses:
    type: File
    outputSource: response/response

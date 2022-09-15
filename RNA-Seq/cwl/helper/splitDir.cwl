cwlVersion: v1.2
class: ExpressionTool
requirements:
  InlineJavascriptRequirement: {}
inputs:
  fqdir: Directory
outputs:
  fq: File[]
expression: '${return {fq: inputs.fqdir.listing};}'

cwlVersion: v1.1
class: CommandLineTool
label: Generate ClinVar Report

requirements:
  DockerRequirement:
    dockerPull: curii/clinvar-report

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

inputs:
  reportfunc:
    type: File
    label: Function used to create HTML report
  sampletxt:
    type: File
    label: Annotated text from VCF
  sample:
    type: string
    label: Sample Name
  headhtml:
    type: File
    format: edam:format_2331 # HTML
    label: Header for HTML report
  tailhtml:
    type: File
    format: edam:format_2331 # HTML
    label: Footer for HTML report

outputs:
  report:
    type: File
    format: edam:format_2331 # HTML
    label: ClinVar variant report
    outputBinding:
      glob: "*html"

baseCommand: python

arguments:
  - $(inputs.reportfunc)
  - $(inputs.sampletxt)
  - $(inputs.sample)
  - $(inputs.headhtml)
  - $(inputs.tailhtml)

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

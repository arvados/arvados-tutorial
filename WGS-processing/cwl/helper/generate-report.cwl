cwlVersion: v1.1
class: CommandLineTool

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
  sampletxt:
    type: File
  headhtml:
    type: File
  tailhtml:
    type: File

outputs:
  report:
    type: File
    outputBinding:
      glob: "*html"

baseCommand: python

arguments:
  - $(inputs.reportfunc)
  - $(inputs.sampletxt)
  - $(inputs.sampletxt.basename)
  - $(inputs.headhtml)
  - $(inputs.tailhtml)

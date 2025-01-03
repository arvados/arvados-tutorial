cwlVersion: v1.2
class: CommandLineTool

inputs:
  llamafile:
    type: 'llamafile-schema.yml#LlamaFile'
  promptstr:
    type: string?
    inputBinding:
      prefix: -p
  promptfile:
    type: File?
    inputBinding:
      prefix: -f
  context:
    type: int?
    inputBinding:
      prefix: "-c"

requirements:
  DockerRequirement:
    dockerImageId: Mozilla-Ocho/llamafile
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 24000
    coresMin: 12
  InitialWorkDirRequirement:
    listing:
      - entryname: ".llamafile"
        entry: $(inputs.llamafile.llamadir)
  WorkReuse:
    enableReuse: false
  arv:ROCmRequirement:
    rocmDeviceCountMin: 1
  SchemaDefRequirement:
    types:
      - {$import: llamafile-schema.yml}

baseCommand: [llamafile, "-ngl", "999", "--no-display-prompt"]
arguments:
  - {prefix: "-m", valueFrom: $(inputs.llamafile.llamafile)}

stdout: response.txt
outputs:
  response:
    type: stdout
  llamacache:
    type: Directory
    outputBinding:
      glob: ".llamafile"

$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"
#  l: "llamafile-schema.yml#"

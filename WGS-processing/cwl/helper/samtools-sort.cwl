cwlVersion: v1.1
class: CommandLineTool
label: Sort BAM

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
  SoftwareRequirement:
    packages:
      Samtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_002105" ]
        version: [ "1.10" ]

inputs:
  bam:
    type: File
    format: edam:format_2572 # BAM
    label: Alignments in BAM format
  sample:
    type: string
    label: Sample Name

outputs:
  sortedbam:
    type: File
    format: edam:format_2572 # BAM
    label: Sorted BAM
    outputBinding:
      glob: "*sorted.bam"

baseCommand: samtools

arguments:
  - sort
  - -@
  - $(runtime.cores)
  - $(inputs.bam.path)
  - -m
  - '2G'
  - -o
  - $(inputs.sample).sorted.bam

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

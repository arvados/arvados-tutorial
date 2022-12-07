cwlVersion: v1.1
class: CommandLineTool
label: Create scatter interval files

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
#    keep_cache: 1024
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2
  SoftwareRequirement:
    packages:
      GATK:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_001876" ]
        version: [ "4.1.7" ]

inputs:
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
    label: Full list of intervals to operate over
  sample:
    type: string
    label: Sample Name
  scattercount:
    type: string
    label: Desired split for variant calling

outputs:
  intervalfiles:
    type: File[]
    label: Scatter intervals files
    outputBinding:
      glob: "intervalfiles/*.interval_list"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - SplitIntervals
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-L"
    valueFrom: $(inputs.fullintervallist)
  - prefix: "--scatter-count"
    valueFrom: $(inputs.scattercount)
  - prefix: "--subdivision-mode"
    valueFrom: "BALANCING_WITHOUT_INTERVAL_SUBDIVISION"
  - prefix: "-O"
    valueFrom: "intervalfiles"

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

cwlVersion: v1.1
class: CommandLineTool
label: Filter unused alternates 

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
    keep_cache: 1024
  ResourceRequirement:
    ramMin: 5000
    coresMin: 2
  SoftwareRequirement:
    packages:
      GATK:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_001876" ]
        version: [ "4.1.7" ]

inputs:
  gvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: GVCF for given interval
    secondaryFiles:
      - .tbi
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
  sample: 
    type: string
    label: Sample Name

outputs:
  filteredgvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: Given interval filtered GVCF 
    outputBinding:
      glob: "*g.vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - SelectVariants 
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "--remove-unused-alternates"
    valueFrom: "true"
  - prefix: "-V"
    valueFrom: $(inputs.gvcf.path)
  - prefix: "-O"
    valueFrom: selected$(inputs.gvcf.basename)

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"

$schemas:
 - https://schema.org/version/latest/schema.rdf
 - http://edamontology.org/EDAM_1.18.owl

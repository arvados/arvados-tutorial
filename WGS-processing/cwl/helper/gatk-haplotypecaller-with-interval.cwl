cwlVersion: v1.1
class: CommandLineTool
label: Call variants with GATK HaplotypeCaller

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
    keep_cache: 1024
  ResourceRequirement:
    ramMin: 3500
    coresMin: 2
  SoftwareRequirement:
    packages:
      GATK:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_001876" ]
        version: [ "4.1.7" ]

inputs:
  bam:
    type: File
    format: edam:format_2572 # BAM
    label: Recalibrated BAM for given interval
    secondaryFiles:
      - .bai
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
  intervallist:
    type: File
    label: Scatter intervals file
  sample:
    type: string
    label: Sample Name

outputs:
  gvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: GVCF for given interval
    secondaryFiles:
      - .tbi
    outputBinding:
      glob: "*vcf.gz"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G" 
  - HaplotypeCaller
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam)
  - prefix: "-L"
    valueFrom: $(inputs.intervallist)
  - prefix: "-O"
    valueFrom: $(inputs.sample)-$(inputs.intervallist.nameroot).gatk.g.vcf.gz
  - prefix: "-ERC"
    valueFrom: "GVCF"
  - prefix: "-GQB"
    valueFrom: "5"
  - prefix: "-GQB"
    valueFrom: "20"
  - prefix: "-GQB"
    valueFrom: "60"

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

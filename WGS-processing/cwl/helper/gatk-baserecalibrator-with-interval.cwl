cwlVersion: v1.1
class: CommandLineTool
label: Generate recalibration table for BQSR

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
  ResourceRequirement:
    ramMin: 5000
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
    label: Indexed sorted BAM with labeled duplicates
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
  sample:
    type: string
    label: Sample Name
  knownsites1:
    type: File
    format: edam:format_3016 # VCF
    label: VCF of known SNPS sites for BQSR
    secondaryFiles:
      - .idx
  knownsites2:
    type: File
    format: edam:format_3016 # VCF
    label: VCF of known indel sites for BQSR
    secondaryFiles:
      - .tbi
  intervallist:
    type: File
    label: Scatter intervals file

outputs:
  recaltable:
    type: File
    label: Recalibration table for given interval
    outputBinding:
      glob: "*.table"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx4G"
  - BaseRecalibrator
  - prefix: "-R"
    valueFrom: $(inputs.reference)
  - prefix: "-I"
    valueFrom: $(inputs.bam)
  - prefix: "--known-sites"
    valueFrom: $(inputs.knownsites1)
  - prefix: "--known-sites"
    valueFrom: $(inputs.knownsites2)
  - prefix: "-L"
    valueFrom: $(inputs.intervallist)
  - prefix: "-O"
    valueFrom: $(inputs.sample)_recal_data.table

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

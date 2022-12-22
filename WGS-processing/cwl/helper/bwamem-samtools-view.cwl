cwlVersion: v1.1
class: CommandLineTool
label: Align FASTQs with BWA

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools
  ShellCommandRequirement: {}

hints:
  arv:RuntimeConstraints:
#    keep_cache: 1024
    outputDirType: keep_output_dir
  ResourceRequirement:
    ramMin: 30000
    coresMin: 16
  SoftwareRequirement:
    packages:
      BWA:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_010910" ]
        version: [ "0.7.17" ]
      Samtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_002105" ]
        version: [ "1.10" ]

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
  fastq1:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R1)
  fastq2:
    type: File
    format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R2)
  sample:
    type: string
    label: Sample Name

stdout: $(inputs.sample).bam

outputs:
  bam:
    type: File
    format: edam:format_2572 # BAM
    label: Alignments in BAM format
    outputBinding:
      glob: "*bam"

arguments:
  - /bwa-0.7.17/bwa
  - mem
  - -M
  - -t
  - $(runtime.cores)
  - $(inputs.reference)
  - -R
  - '@RG\tID:sample\tSM:sample\tLB:sample\tPL:ILLUMINA\tPU:sample1'
  - -c
  - '250'
  - $(inputs.fastq1)
  - $(inputs.fastq2)
  - shellQuote: false
    valueFrom: '|'
  - samtools
  - view
  - -@
  - $(runtime.cores)
  - -b
  - -S
  - shellQuote: false
    valueFrom: '-'

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

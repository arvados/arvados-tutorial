$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html
cwlVersion: v1.1
class: CommandLineTool
label: Convert one chromosome of bam to fastqs
requirements:
  ShellCommandRequirement: {}
hints:
  DockerRequirement:
    dockerPull: curii/bwa-samtools
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4
  arv:RuntimeConstraints:
    keep_cache: 9216
    outputDirType: keep_output_dir
  SoftwareRequirement:
    packages:
      Samtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_002105" ]
        version: [ "1.10" ]
inputs:
  bam:
    type: File
    #format: edam:format_2572 # BAM
    label: Alignments in BAM format
    secondaryFiles: [.bai]
  sample:
    type: string
    label: Sample name
  chrom:
    type: string
    label: Chromosome name
outputs:
  fastq1:
    type: File
    #format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R1)
    outputBinding:
      glob: "*_1.fastq.gz"
  fastq2:
    type: File
    #format: edam:format_1930 # FASTQ
    label: One of set of pair-end FASTQs (R2)
    outputBinding:
      glob: "*_2.fastq.gz"
baseCommand: [samtools, view]
arguments:
  - "-b"
  - $(inputs.bam)
  - $(inputs.chrom)
  - shellQuote: false
    valueFrom: "|"
  - "samtools"
  - "sort"
  - "-n"
  - "-"
  - shellQuote: false
    valueFrom: "|"
  - "samtools"
  - "fastq"
  - "-@"
  - $(runtime.cores)
  - "-"
  - "-N"
  - prefix: "-0"
    valueFrom: "/dev/null"
  - prefix: "-s"
    valueFrom: "/dev/null"
  - prefix: "-1"
    valueFrom: $(inputs.sample)_1.fastq.gz
  - prefix: "-2"
    valueFrom: $(inputs.sample)_2.fastq.gz

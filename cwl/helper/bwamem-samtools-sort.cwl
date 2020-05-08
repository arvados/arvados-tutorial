cwlVersion: v1.1
class: CommandLineTool
label: Realigning fastqs and converting output to bam
$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  ShellCommandRequirement: {}
  ResourceRequirement:
    ramMin: 20000 
    coresMin: 16 

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
    keep_cache: 9216

inputs:
  reference:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .pac
      - .sa
      - .fai
      - ^.dict
  fastq1: File
  fastq2: File
  sample: string

stdout: $(inputs.sample).bam

outputs:
  bam:
    type: File
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
  - sort 
  - -@
  - '16'
  - -m
  - '500M'
  - -l
  - '6'
  - -o
  - $(inputs.sample).sorted.bam

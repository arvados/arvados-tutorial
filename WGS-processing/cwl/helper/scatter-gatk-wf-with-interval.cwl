cwlVersion: v1.1
class: Workflow
label: Scattered variant calling workflow

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

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
  fullintervallist:
    type: File
    label: Full list of intervals to operate over
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
  scattercount:
    type: string
    label: Desired split for variant calling

outputs:
  gatheredgvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: Gathered GVCF
    secondaryFiles:
      - .tbi
    outputSource: gather-GVCFs/gatheredgvcf
    
steps:
  splitintervals:
    run: gatk-splitintervals.cwl
    in:
      reference: reference
      fullintervallist: fullintervallist
      sample: sample
      scattercount: scattercount
    out: [intervalfiles]
      
  recal-haplotypecaller:
    run: gatk-wf-with-interval.cwl
    scatter: intervallist
    in:
      bam: bam
      reference: reference
      sample: sample
      knownsites1: knownsites1
      knownsites2: knownsites2
      intervallist: splitintervals/intervalfiles
    out: [gvcf]

  gather-GVCFs:
    run: gather-array-vcf.cwl
    in:
      gvcfarray: recal-haplotypecaller/gvcf
      sample: sample
      reference: reference
    out: [gatheredgvcf]

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

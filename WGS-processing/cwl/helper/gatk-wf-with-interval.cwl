cwlVersion: v1.1
class: Workflow
label: Variant calling workflow for single interval 

requirements:
  - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    secondaryFiles:
      - .bai
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
  sample: string
  knownsites1:
    type: File
    secondaryFiles:
      - .tbi
  intervallist:
    type: File

outputs:
  gvcf:
    type: File
    outputSource: selectvariants/filteredgvcf

steps:
  basecalibrator:
    run: gatk-baserecalibrator-with-interval.cwl
    in:
      bam: bam
      reference: reference
      sample: sample
      knownsites1: knownsites1
      intervallist: intervallist
    out: [recaltable]
  applyBQSR:
    run: gatk-applyBSQR-with-interval.cwl
    in: 
      reference: reference
      bam: bam
      sample: sample
      intervallist: intervallist
      recaltable: basecalibrator/recaltable
    out: [recalbam]
  haplotypecaller:
    run: gatk-haplotypecaller-with-interval.cwl
    in:
      reference: reference
      bam: applyBQSR/recalbam
      sample: sample
      intervallist: intervallist
    out: [gvcf]
  selectvariants:
    run: gatk-selectvariants.cwl
    in: 
      gvcf: haplotypecaller/gvcf
      reference: reference
      sample: sample
    out: [filteredgvcf]

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

$schemas:
 - https://schema.org/version/latest/schema.rdf
 - http://edamontology.org/EDAM_1.18.owl

cwlVersion: v1.1
class: CommandLineTool
label: Convert GVCF to VCF

requirements:
  - class: DockerRequirement
    dockerPull: curii/clinvar-report
  - class: ShellCommandRequirement

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4
  SoftwareRequirement:
    packages:
      BCFtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_005227" ]
        version: [ "1.10.2" ]
      HTSlib:
        version: [ "1.10.2" ]
        
inputs:
  sample:
    type: string
    label: Sample Name
  gvcf:
    type: File
    format: edam:format_3016 # GVCF
    label: GVCF generated from GATK
  
outputs:
  vcf:
    type: File
    format: edam:format_3016 # VCF
    label: VCF extracted from GVCF
    outputBinding:
      glob: "*.vcf.gz"
    secondaryFiles: [.tbi]

arguments:
  - bcftools
  - view
  - prefix: "--min-ac"
    valueFrom: "1"
  - $(inputs.gvcf.path)
  - prefix: "-i"
    valueFrom: "AVG(GQ)>20"
  - valueFrom: "-Ov"
  - prefix: "-o"
    valueFrom: $(inputs.sample).vcf
  - {valueFrom: '&&', shellQuote: false}
  - bgzip
  - valueFrom: $(inputs.sample).vcf
  - {valueFrom: '&&', shellQuote: false}
  - tabix
  - valueFrom: $(inputs.sample).vcf.gz

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

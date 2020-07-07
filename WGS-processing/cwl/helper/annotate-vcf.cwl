cwlVersion: v1.1
class: CommandLineTool
label: Annotate and filter VCF

requirements:
  DockerRequirement:
    dockerPull: curii/clinvar-report
  ShellCommandRequirement: {}

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4
  SoftwareRequirement:
    packages:
      BCFtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_005227" ]
        version: [ "1.10.2" ]

stdout: $(inputs.vcf.nameroot).txt

inputs:
  vcf:
    type: File
    format: edam:format_3016 # VCF
    label: VCF extracted from GVCF
    secondaryFiles: [.tbi]
  clinvarvcf:
    type: File
    format: edam:format_3016 # VCF
    label: Reference VCF for ClinVar

outputs:
  reporttxt: stdout

arguments:
  - bcftools
  - annotate
  - prefix: "-a"
    valueFrom: $(inputs.clinvarvcf.path)
  - prefix: "-c"
    valueFrom: "ID,INFO"
  - $(inputs.vcf.path)
  - {valueFrom: '|', shellQuote: false}
  - bcftools
  - filter
  - prefix: "-i"
    valueFrom: "INFO/ALLELEID>=1"
  - {valueFrom: '|', shellQuote: false}
  - bcftools
  - query
  - prefix: "-f"
    valueFrom: "%ID\t%CHROM\t%POS\t%REF\t%ALT\t%INFO/ALLELEID\t%INFO/CLNSIG\t%INFO/CLNDN\t%INFO/AF_ESP\t%INFO/AF_EXAC\t%INFO/AF_TGP[\t%GT]\n"

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

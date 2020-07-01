cwlVersion: v1.1
class: CommandLineTool
label: Annotate and filter VCF

requirements:
  - class: DockerRequirement
    dockerPull: curii/clinvar-report
  - class: ShellCommandRequirement

hints:
  ResourceRequirement:
    ramMin: 10000
    coresMin: 4

stdout: $(inputs.vcf.nameroot).txt

inputs:
  vcf:
    type: File
  clinvarvcf:
    type: File

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

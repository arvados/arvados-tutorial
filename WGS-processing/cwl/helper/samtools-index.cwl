cwlVersion: v1.1
class: CommandLineTool
label: Index BAM

requirements:
  DockerRequirement:
    dockerPull: curii/bwa-samtools-picard
  InitialWorkDirRequirement:
    listing:
      - $(inputs.bam)

hints:
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
  SoftwareRequirement:
    packages:
      Samtools:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_002105" ]
        version: [ "1.10" ]

inputs:
  bam: 
    type: File
    format: edam:format_2572 # BAM
    label: Sorted BAM with labeled duplicates

outputs:
  indexedbam:
    type: File
    format: edam:format_2572 # BAM
    label: Indexed sorted BAM with labeled duplicates 
    outputBinding:
      glob: "*bam"
    secondaryFiles:
      - .bai 

baseCommand: samtools

arguments:
  - index
  - $(inputs.bam.basename)

s:codeRepository: https://github.com/arvados/arvados-tutorial
s:license: https://www.gnu.org/licenses/agpl-3.0.en.html

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/
 arv: "http://arvados.org/cwl#"
 cwltool: "http://commonwl.org/cwltool#"

$schemas:
 - https://schema.org/version/latest/schema.rdf
 - http://edamontology.org/EDAM_1.18.owl

cwlVersion: v1.1
class: CommandLineTool
label: Mark duplicates using GATK (Picard) 

requirements:
  DockerRequirement:
    dockerPull: broadinstitute/gatk:4.1.7.0

hints:
  ResourceRequirement:
    ramMin: 20000
    coresMin: 4    
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir
  SoftwareRequirement:
    packages:
      GATK:
        specs: [ "https://identifiers.org/rrid/RRID:SCR_001876" ]
        version: [ "4.1.7" ]

inputs:
  bam:
    type: File
    format: edam:format_2572 # BAM
    label: Sorted BAM 

outputs:
  dupbam:
    type: File
    format: edam:format_2572 # BAM
    label: Sorted BAM with labeled duplicates
    outputBinding:
      glob: "*.bam"
  dupmetrics:
    type: File
    label: Duplication metrics file
    outputBinding:
      glob: "*.txt"

baseCommand: /gatk/gatk

arguments:
  - "--java-options"
  - "-Xmx8G" 
  - MarkDuplicates
  - prefix: "-I"
    valueFrom: $(inputs.bam.path)
  - prefix: "-O"
    valueFrom: marked_dups$(inputs.bam.basename)
  - prefix: "-M"
    valueFrom: "metrics.txt"

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

cwlVersion: v1.1
class: CommandLineTool
$namespaces:
  arv: "http://arvados.org/cwl#"
  cwltool: "http://commonwl.org/cwltool#"

requirements:
  - class: DockerRequirement
    dockerPull: curii/bam2fastq
  - class: ShellCommandRequirement

hints:
  ResourceRequirement:
    ramMin: 4000
    coresMin: 1 
    tmpdirMin: 150000 
  arv:RuntimeConstraints:
    outputDirType: keep_output_dir

inputs:
  tarzipbam: File
  samplename: string

outputs:
  fastqs:
    type: File[]
    outputBinding:
      glob: "*fastq"

arguments:
  - tar
  - prefix: "-xvf" 
    valueFrom: $(inputs.tarzipbam.path)
  - prefix: "-C"
    valueFrom: $(runtime.tmpdir)
  - {valueFrom: '&&', shellQuote: false}
  - samtools
  - merge
  - {valueFrom: $(runtime.tmpdir)/$(inputs.samplename).bam, shellQuote: false}
  - {valueFrom: $(runtime.tmpdir)/*.bam, shellQuote: false}
  - {valueFrom: '&&', shellQuote: false}
  - /bam2fastq/bam2fastq  
  - {valueFrom: $(runtime.tmpdir)/$(inputs.samplename).bam, shellQuote: false}
  - prefix: "-o"
    valueFrom: $(inputs.samplename)_R#.fastq

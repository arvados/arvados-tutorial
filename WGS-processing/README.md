This directory contains an Arvados demo showing processing of whole genome sequencing (WGS) data. The workflow includes:

* Check of fastq quality using FastQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 
* Local alignment using BWA-MEM (http://bio-bwa.sourceforge.net/bwa.shtml)
* Variant calling in parallel using GATK Haplotype Caller (https://gatk.broadinstitute.org/hc/en-us)
* Generation of an HTML report comparing variants against ClinVar archive (https://www.ncbi.nlm.nih.gov/clinvar/)

Workflows are written in CWL v1.1. (https://www.commonwl.org/)

Subdirectories are:
* cwl - contains CWL code for the demo
* yml - contains YML inputs for cwl demo code
* src - contains any src code for the demo
* docker - contains dockerfiles necessary to re-create any needed docker images 

To run the workflow:

*  arvados-cwl-runner --no-wait --project-uuid YOUR_PROJECT_UUID ./cwl/wgs-processing-wf.cwl ./yml/YOURINPUTS.yml

About the Demo Data:

WGS Data used in this demo is public data made available by the Personal Genome Project.  
This set of data is from the PGP-UK (https://www.personalgenomes.org.uk/). 

Have questions about Arvados?
* https://arvados.org/
* https://gitter.im/arvados/community

Have questions about CWL?
* https://www.commonwl.org/
* https://cwl.discourse.group/
* https://gitter.im/common-workflow-language/common-workflow-language

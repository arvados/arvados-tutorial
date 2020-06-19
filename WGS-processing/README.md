This directory contains an Arvados demo showing processing of whole genome sequencing (WGS) data. The workflow includes:

* Check of fastq quality 
* Local alignment using BWA-MEM
* Variant calling in parallel using GATK
* Generation of an HTML report comparing variants against ClinVar archive 

Workflows are written in CWL v1.1. 

Subdirectories are:
* cwl - contains CWL code for the demo
* yml - contains yml inputs for cwl demo code
* src - contains any src code for the demo
* docker - contains dockerfiles necessary to re-create any needed docker images 

To run the workflow:

* cd into cwl directory

* run the following
  arvados-cwl-runner --no-wait --project-uuid YOUR_PROJECT_UUID wgs-processing-wf.cwl ../yml/YOURINPUTS.yml

About the Demo Data:
WGS Data used in this demo is public data made available by the Personal Genome Project.  This data is from the PGP-UK (https://www.personalgenomes.org.uk/). 

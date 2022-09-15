This directory contains an Arvados demo that performs bioinformatics RNA-seq analysis. However, specific knowledge of the biology of RNA-seq is not required for this demo. For those unfamiliar with RNA-seq, it is the process of sequencing RNA present in a biological sample. From the sequence reads, we want to measure the relative numbers of different RNA molecules appearing in the sample that were produced by particular genes. This analysis is called “differential gene expression”. 

Workflows are written in CWL v1.2. (https://www.commonwl.org/)

Subdirectories are:
* cwl - contains CWL code for the demo
* yml - contains YML inputs for cwl demo code
* docker - contains dockerfiles necessary to re-create any needed docker images 

To run the workflow:

*  arvados-cwl-runner --no-wait --project-uuid YOUR_PROJECT_UUID ./cwl/RNA-seq-wf.cwl ./yml/RNA-seq-wf.yml


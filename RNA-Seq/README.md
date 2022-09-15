This directory contains an Arvados demo that performs bioinformatics RNA-seq analysis. However, specific knowledge of the biology of RNA-seq is not required for this demo. For those unfamiliar with RNA-seq, it is the process of sequencing RNA present in a biological sample. From the sequence reads, we want to measure the relative numbers of different RNA molecules appearing in the sample that were produced by particular genes. This analysis is called “differential gene expression”. 

Workflows are written in CWL v1.2. (https://www.commonwl.org/)

Subdirectories are:
* cwl - contains CWL code for the demo
* yml - contains YML inputs for cwl demo code

To run the workflow:

*  arvados-cwl-runner --no-wait --project-uuid YOUR_PROJECT_UUID ./cwl/RNA-seq-wf.cwl ./yml/RNA-seq-wf.yml

About the Demo:
This demo is based on a workflow in the Introduction to RNA-seq using high-performance computing (HPC) lessons developed by members of the teaching team at the Harvard Chan Bioinformatics Core (HBC). The original training, which includes additional lectures about the biology of RNA-seq, can be found at here:https://github.com/hbctraining/Intro-to-rnaseq-hpc-O2. 

The data used in this demo can be found here: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE50499. Citation: Kenny PJ, Zhou H, Kim M, Skariah G et al. MOV10 and FMRP regulate AGO2 association with microRNA recognition elements. Cell Rep 2014 Dec 11;9(5):1729-1741. PMID: 25464849

Have questions about Arvados?
* https://arvados.org/
* https://gitter.im/arvados/community

Have questions about CWL?
* https://www.commonwl.org/
* https://cwl.discourse.group/
* https://gitter.im/common-workflow-language/common-workflow-language


import numpy as np
import scipy as scipy
import pandas as pd
import io
import argparse

def tablegeneration(reportdata,sectionlabel):
    labelhtml = '<h2>'+sectionlabel+'</h2>'
    # creating html table from dataframe
    reportdatasub = reportdata[["Variant ID", "Allele ID", "Clinical Significance","Disease Name", "Frequency EXAC", "Frequency 1000 Genomes Project","Zygosity","URL"]]

    reportdatasub['Disease Name'] = reportdatasub['Disease Name'].str.replace('|','<br/>')
    str_io = io.StringIO()
    reportdatasub.to_html(buf=str_io, classes='table table-bordered',index_names=False,index=False)
    html_str = str_io.getvalue()
    html_str_encoded = unicode(html_str).encode('utf8')
    html_str_encoded = html_str_encoded.replace('&lt;','<')
    html_str_encoded = html_str_encoded.replace('&gt;','>')
    html_str_encoded = html_str_encoded.replace('_',' ')
    section_html = labelhtml+html_str_encoded
    return section_html

def generatereport():

    parser = argparse.ArgumentParser()
    parser.add_argument('txtfilename', metavar='VCF2TXTFILENAME', help='text file of info to annotate')
    parser.add_argument('samplename', metavar='SAMPLENAME', help='name of sample to use on report')
    parser.add_argument('headfile', metavar='REPORTHEADHTML', help='head html for report')
    parser.add_argument('tailfile', metavar='REPORTTAILHTML', help='tail html for report')
    args = parser.parse_args()

    pd.set_option("display.max_colwidth", 10000)

#    filename = "reportdata.txt"
#    samplename = "hu34D5B9_var-GS000015891-ASM"
#    headfile = "head.html"
#    tailfile = "tail.html"

    filename = args.txtfilename
    samplename = args.samplename
    headfile = args.headfile
    tailfile = args.tailfile

    # reading data into dataframe
    headerlist = ["Variant ID", "Chromosome", "Position", "Ref","Alt","Allele ID", "Clinical Significance","Disease Name","Frequency GO-ESP", "Frequency EXAC", "Frequency 1000 Genomes Project","GT"]
    reportdata = pd.read_csv(filename,header=0,names=headerlist,sep='\t')
    
    # defining zygosity
    reportdata['Zygosity'] = reportdata.GT

    # creating url from variant ID
    clinvarURL =  "https://www.ncbi.nlm.nih.gov/clinvar/variation/" 
    reportdata['URL'] = '<a href=' + clinvarURL + reportdata['Variant ID'].apply(str) + '> Link to ClinVar</a>'
    reportdata.to_json('test.json',orient='records')
    str_io = io.StringIO()

    idxP = reportdata['Clinical Significance'].str.contains('Pathogenic')
    idxLP = reportdata['Clinical Significance'].str.contains('Likely_pathogenic')
    idxD = reportdata['Clinical Significance'].str.contains('drug_response') 
    idxPro = reportdata['Clinical Significance'].str.contains('protective')
    idxRisk = reportdata['Clinical Significance'].str.contains('risk_factor')
    idxA = reportdata['Clinical Significance'].str.contains('Affects')
    idxB = reportdata['Clinical Significance'].str.contains('Benign')
    idxLB = reportdata['Clinical Significance'].str.contains('Likely_benign') 
    idxAs = reportdata['Clinical Significance'].str.contains('association')

    idxOther = ~(idxAs | idxLB | idxB | idxA | idxRisk | idxPro | idxD | idxP | idxLP)
 
    html_file = open(headfile, 'r')
    source_code_head = html_file.read() 
    source_code_head = source_code_head.replace('ClinVar Report','ClinVar Report For ' + samplename)
    html_file.close()

    html_file = open(tailfile, 'r')
    source_code_tail = html_file.read()
    html_file.close()
 
    pathogenic_html = tablegeneration(reportdata[idxP],'Pathogenic')
    likely_pathogenic_html = tablegeneration(reportdata[idxLP],'Likely Pathogenic') 
    drug_html = tablegeneration(reportdata[idxD],'Drug Response')
    protective_html = tablegeneration(reportdata[idxPro],'Protective')
    risk_html = tablegeneration(reportdata[idxRisk],'Risk Factor')
    affects_html = tablegeneration(reportdata[idxA],'Affects')
    association_html = tablegeneration(reportdata[idxAs],'Association')
    benign_html = tablegeneration(reportdata[idxB],'Benign')
    likely_benign_html = tablegeneration(reportdata[idxLB],'Likely Benign')
    other_html = tablegeneration(reportdata[idxOther],'Other') 

    # combine html table with head and tail html for total report
    total_html = source_code_head + pathogenic_html + likely_pathogenic_html + drug_html + protective_html + risk_html + affects_html + association_html + other_html + benign_html + likely_benign_html + source_code_tail
  
    # write out report html
    f = open(samplename+'.html','wb')
    f.write(total_html)
    f.close()

if __name__ == '__main__':
    generatereport()

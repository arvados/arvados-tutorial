import numpy as np
import scipy as scipy
import pandas as pd
import io
import argparse

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
    reportdata['Zygosity']="."

    # defining zygosity
    idxHOM1 = reportdata.GT=='1|1' 
    idxHOM2 = reportdata.GT=='1/1'
    idxHET1 = reportdata.GT=='1|0'
    idxHET2 = reportdata.GT=='1/0'
    idxHET3 = reportdata.GT=='0|1'
    idxHET4 = reportdata.GT=='0/1'
    idxHOM = idxHOM1 | idxHOM2
    idxHET = idxHET1 | idxHET2 | idxHET3 | idxHET4
    reportdata.Zygosity[idxHOM]='HOM'
    reportdata.Zygosity[idxHET]='HET'

    # creating url from variant ID
    reportdata['URL'] = '<a href="http://www.mywebsite.com/about.html">About</a>'
    reportdata.to_json('test.json',orient='records')
    str_io = io.StringIO()

    # creating html table from dataframe
    reportdatasub = reportdata[["Variant ID", "Allele ID", "Clinical Significance","Disease Name", "Frequency EXAC", "Frequency 1000 Genomes Project","Zygosity","URL"]]
    reportdatasub.to_html(buf=str_io, classes='table table-bordered',index_names=False,index=False)
    html_str = str_io.getvalue()
    html_str_encoded = unicode(html_str).encode('utf8')
    html_str_encoded = html_str_encoded.replace('&lt;','<')
    html_str_encoded = html_str_encoded.replace('&gt;','>')
    html_str_encoded = html_str_encoded.replace('|','<br/>')

    html_file = open(headfile, 'r')
    source_code_head = html_file.read() 
    html_file.close()

    html_file = open(tailfile, 'r')
    source_code_tail = html_file.read()
    html_file.close()

    # combine html table with head and tail html for total report
    total_html = source_code_head + html_str_encoded + source_code_tail
  
    # write out report html
    f = open(samplename+'.html','wb')
    f.write(total_html)
    f.close()

if __name__ == '__main__':
    generatereport()

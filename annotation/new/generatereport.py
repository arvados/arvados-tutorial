import numpy as np
import scipy as scipy
import pandas as pd
import io

pd.set_option("display.max_colwidth", 10000)

filename = "reportdata.txt"
samplename = "hu34D5B9_var-GS000015891-ASM"
headfile = "head.html"
tailfile = "tail.html"

headerlist = ["Variant ID", "Chromosome", "Position", "Ref","Alt","Allele ID", "Clinical Significance","Disease Name","Frequency GO-ESP", "Frequency EXAC", "Frequency 1000 Genomes Project","GT"]
reportdata = pd.read_csv(filename,header=0,names=headerlist,sep='\t')
reportdata['Zygosity']="."

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

#reportdata['URL'] =reportdata['Variant ID'].apply(lambda x: '<a href="www.ncbi.nlm.nih.gov/clinvar/variation/'+str(x)+'> Link </a>')
reportdata['URL'] = '<a href="http://www.mywebsite.com/about.html">About</a>'
reportdata.to_json('test.json',orient='records')
str_io = io.StringIO()

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


total_html = source_code_head + html_str_encoded + source_code_tail

f = open(samplename+'.html','wb')

f.write(total_html)
f.close()

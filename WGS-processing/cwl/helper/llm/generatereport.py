import pandas
import io
import argparse

from Bio import Entrez
import json
from pprint import pprint
import time

def reportvariants(reportdata):
    eid = []
    for idx, row in reportdata.iterrows():
        eid.append(str(row["Variant ID"]))

    ef = Entrez.esummary(db="clinvar", id=",".join(eid), rettype='vcv', retmode='json')
    rec = json.load(ef)
    #print(json.dumps(rec, indent=2))

    for eid in rec["result"]:
        if eid == "uids":
            continue
        #if rec["result"][eid]["germline_classification"]["description"] == "Benign":
        #    continue

        var = rec["result"][eid]

        if "error" in var:
            continue

        if "germline_classification" not in var:
            pprint(var)
            continue

        gc = var["germline_classification"]

        print()
        print("Gene:", var["gene_sort"])
        print("Variant:", var["title"])
        print("Clinical significance:", gc["description"])
        for tr in gc["trait_set"]:
            if tr["trait_name"] == "not provided":
                continue
            print("- Associated trait:", tr["trait_name"])
            for xref in tr["trait_xrefs"]:
                if xref["db_source"] == "MedGen":
                    #print(xref["db_id"])
                    #medgen = Entrez.esummary(db="medgen", id=xref["db_id"].lstrip("C0"), retmode='json')
                    medgen = Entrez.esearch(db="medgen", term=xref["db_id"]+"[conceptid]", retmode='json')
                    md = json.load(medgen)
                    #print(json.dumps(md, indent=2))

                    medgenid = md["esearchresult"]["idlist"][0]
                    medgen = Entrez.esummary(db="medgen", id=md["esearchresult"]["idlist"][0], retmode='json')
                    md = json.load(medgen)
                    #print(json.dumps(md, indent=2))
                    if "value" in md["result"][medgenid]["definition"]:
                        print(md["result"][medgenid]["definition"]["value"])

                    time.sleep(.5)


def generatereport():

    parser = argparse.ArgumentParser()
    parser.add_argument('txtfilename', metavar='VCF2TXTFILENAME', help='text file of info to annotate')
    parser.add_argument('samplename', metavar='SAMPLENAME', help='name of sample to use on report')
    args = parser.parse_args()

    pandas.set_option("display.max_colwidth", 10000)

#    filename = "reportdata.txt"
#    samplename = "hu34D5B9_var-GS000015891-ASM"
#    headfile = "head.html"
#    tailfile = "tail.html"

    filename = args.txtfilename
    samplename = args.samplename

    # reading data into dataframe
    headerlist = ["Variant ID", "Chromosome", "Position", "Ref","Alt","Allele ID", "Clinical Significance","Disease Name","Frequency GO-ESP", "Frequency EXAC", "Frequency 1000 Genomes Project","GT"]
    reportdata = pandas.read_csv(filename,header=0,names=headerlist,sep='\t')

    # defining zygosity
    reportdata['Zygosity'] = reportdata.GT

    # creating url from variant ID
    #clinvarURL =  "https://www.ncbi.nlm.nih.gov/clinvar/variation/"
    #reportdata['URL'] = '<a href=' + clinvarURL + reportdata['Variant ID'].apply(str) + '> Link to ClinVar</a>'
    #reportdata.to_json('test.json',orient='records')
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

    #pathogenic_html = tablegeneration(reportdata[idxP],'Pathogenic')

    Entrez.email = "peter.amstutz@curii.com"

    reportvariants(reportdata[idxP])
    reportvariants(reportdata[idxLP])
    reportvariants(reportdata[idxD])
    reportvariants(reportdata[idxPro])
    reportvariants(reportdata[idxRisk])
    reportvariants(reportdata[idxA])
    #reportvariants(reportdata[idxAs])

    # likely_pathogenic_html = tablegeneration(reportdata[idxLP],'Likely Pathogenic')
    # drug_html = tablegeneration(reportdata[idxD],'Drug Response')
    # protective_html = tablegeneration(reportdata[idxPro],'Protective')
    # risk_html = tablegeneration(reportdata[idxRisk],'Risk Factor')
    # affects_html = tablegeneration(reportdata[idxA],'Affects')
    # association_html = tablegeneration(reportdata[idxAs],'Association')
    # benign_html = tablegeneration(reportdata[idxB],'Benign')
    # likely_benign_html = tablegeneration(reportdata[idxLB],'Likely Benign')
    # other_html = tablegeneration(reportdata[idxOther],'Other')

if __name__ == '__main__':
    generatereport()

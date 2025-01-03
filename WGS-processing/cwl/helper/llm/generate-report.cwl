#!/usr/bin/env cwl-runner
cwlVersion: v1.1
class: CommandLineTool
label: Generate ClinVar Report

requirements:
  DockerRequirement:
    dockerImageId: curii/biopython
    dockerFile: |
      FROM python:3.11-bullseye
      RUN pip install --no-cache-dir pandas PyPDF2 biopython

hints:
  ResourceRequirement:
    ramMin: 2000
    coresMin: 1
  NetworkAccess:
    networkAccess: true

inputs:
  reportfunc:
    type: File
    label: Function used to create HTML report
    default:
      class: File
      location: generatereport.py
  sampletxt:
    type: File
    label: Annotated text from VCF
  sample:
    type: string
    label: Sample Name

stdout: "report.txt"

outputs:
  report: stdout

baseCommand: python

arguments:
  - $(inputs.reportfunc)
  - $(inputs.sampletxt)
  - $(inputs.sample)

$namespaces:
 s: https://schema.org/
 edam: http://edamontology.org/

#$schemas:
# - https://schema.org/version/latest/schema.rdf
# - http://edamontology.org/EDAM_1.18.owl

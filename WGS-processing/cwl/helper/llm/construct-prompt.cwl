cwlVersion: v1.2
class: CommandLineTool

inputs:
  promptprefix: File?
  reportfile: File
  questions: File?

  script:
    type: File
    default:
      class: File
      contents: |
        from PyPDF2 import PdfReader
        import sys

        if len(sys.argv) > 2:
            with open(sys.argv[2]) as f:
                print(f.read())

        if sys.argv[1].endswith(".pdf"):
            print("The following text has extra spaces inserted into words, breaking them into word fragments.  Please ignore the extra spaces when processing this text.")
            print()
            reader = PdfReader(sys.argv[1])
            for page in reader.pages:
                print(page.extract_text())
            print()
            print("The previous text has extra spaces inserted into words, breaking them into word fragments.  Please ignore the extra spaces when processing this text.")

        if sys.argv[1].endswith(".txt"):
            with open(sys.argv[1]) as f:
                print(f.read())

        if len(sys.argv) > 3:
            with open(sys.argv[3]) as f:
                print(f.read())

requirements:
  DockerRequirement:
    dockerImageId: curii/extractpdf
    dockerFile: |
      FROM python:3.11-bullseye
      RUN pip install --no-cache-dir PyPDF2

stdout: $(inputs.reportfile.basename).txt
arguments: [python3, $(inputs.script), $(inputs.reportfile), $(inputs.promptprefix), $(inputs.questions)]

outputs:
  text: stdout

import os
import docx
import subprocess
import re


class clearMetadata:

    def __init__(self):
        self.infile_path = r'C:\Users\TOPHER-LAPTOP\Desktop\SeniorAE\scratch\metadata\test.docx'
        self.outfile_path = self.infile_path.replace('.docx', '.PDF')
        self.libre_log = r'libre_log.txt'
        self.python_log = r'python_log.txt'
        self.currdir = os.getcwd()

    # Clear previous log files
    def logInitiate(self):
        for file in [self.python_log, self.libre_log]:
            try:
                os.remove(os.path.join(self.currdir, file))
            except Exception:
                print(f'Could not remove {file}')

    # Convert docx to pdf using python library, convert doc file to pdf using built reader
    def clearWordPython(self):
        doc = docx.Document(self.infile_path)
        full_text = []
        # Iterate through all of the paragraphs in file
        for paragraph in doc.paragraphs:
            full_text.append(paragraph.text)
        full_text_str = '\n'.join(full_text)
        print(full_text_str)

        # Save to a pdf file

    # Convert to PDF using libra office and command line
    def clearWordLibre(self):
        librewriter = r'C://"Program Files"/LibreOffice/program/swriter.exe'
        args = [librewriter, '--headless', '--convert-to', 'pdf', '--outdir', self.currdir, self.infile_path]
        sub_string = f'{args} --convert-to pdf --outdir "{self.currdir}" "{self.infile_path}"'
        process = subprocess.run(args, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)


if __name__ == '__main__':
    clear = clearMetadata()

    clear.logInitiate()
    clear.clearWordPython()
    clear.clearWordLibre()


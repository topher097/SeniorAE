import os
import zipfile
import pandas as pd
import comtypes.client
import time
import shutil


class clearMetadata:
    # Initialize variables
    def __init__(self, directory_path):
        self.excel_ext = ['.xlsx', '.xls']
        self.word_ext = ['.docx', '.doc']
        self.dpath = directory_path
        self.clear_ext = ['.pdf'] + self.excel_ext + self.word_ext
        self.clean_list = []
        self.current_dir = os.getcwd()
        self.word_counter = 0
        self.excel_counter = 0
        self.word = comtypes.client.CreateObject('Word.Application')         # Open word
        self.root = ''
        self.file_basename = ''
        self.file_ext = ''
        self.file = ''

    # Unzip all files in directory (if any)
    def unZipFiles(self):
        os.chdir(self.dpath)
        for item in os.listdir(self.dpath):
            if item.endswith('.zip'):
                file_name = os.path.abspath(item)
                zip_ref = zipfile.ZipFile(file_name)    # create zipfile object
                zip_ref.extractall(self.dpath)          # extract file to dir
                zip_ref.close()                         # close file
                os.remove(file_name)                    # delete zipped file
                print(f'Un-zipped {item}')

    # Find the files which may contain metadata, store path to file in a list
    def findFiles(self):
        for root, dpath, files in os.walk(self.dpath):
            for file in files:
                file_basename, file_extension = os.path.splitext(os.path.basename(file))
                if file_extension in self.clear_ext and '_COPY' not in file_basename:
                    print(f'"{file}" may have metadata')
                    file_full_path = os.path.join(root, file)
                    self.clean_list.append(file_full_path)

    # Clear metadata by re-writing or printing as pdf
    def cleanFiles(self):
        for file in self.clean_list:
            self.file = file
            self.file_basename, self.file_ext = os.path.splitext(os.path.basename(file))
            self.root = os.path.dirname(file)

            # Clean the excel file by converting to csv
            if self.file_ext in self.excel_ext:
                clearMetadata.cleanExcel(self)

            # Clean word file by printing to pdf
            if self.file_ext in self.word_ext:
                clearMetadata.cleanWord(self)
        self.word.Quit()

    def cleanWord(self):
        self.word_counter += 1
        start_time = time.time()

        pdf_file_temp = 'temp.PDF'
        pdf_file = self.file_basename + f'_wordconvert{self.word_counter}.PDF'      # New name for file
        doc = self.word.Documents.Open(self.file)  # Open word file
        doc.SaveAs(os.path.join(self.root, pdf_file_temp), FileFormat=17)           # Save as PDF
        doc.Close()                                                                 # Close word file
        shutil.copyfile(os.path.join(self.root, pdf_file_temp), os.path.join(self.root, pdf_file))
        os.remove(pdf_file_temp)                                                    # Remove the temp file
        end_time = time.time()
        print(f'Converting "{self.file_basename + self.file_ext}" to "{pdf_file}" in {round((end_time - start_time) * 1000, 4)} ms')

    # Clean Excel file by converting to csv file(s)
    def cleanExcel(self):
        self.excel_counter += 1
        excel = pd.ExcelFile(self.file)                                     # Open Excel file
        sheet_names = excel.sheet_names                                     # Get list of names of sheets
        for sheet in sheet_names:
            start_time = time.time()
            excel_data = excel.parse(sheet)                                 # Parse Excel data
            if not excel_data.empty:
                csv_file = self.file_basename + '_' + sheet + f'{self.excel_counter}.csv'
                csv_path = os.path.join(self.root, csv_file)
                if os.path.exists(csv_path):
                    os.remove(csv_path)
                excel_data.to_csv(csv_path, sep=',', encoding='utf-8', index=False)
                end_time = time.time()
                print(f'Converting "{self.file_basename + self.file_ext}" to "{csv_file}" in {round((end_time - start_time) * 1000, 4)} ms')


# Run the cleaner
if __name__ == '__main__':
    # Specify directory which you want to search
    directory_path = r'C:\Python\SeniorAE\scratch\metadata\AE483_Lab2_Materials'

    # Clean files
    clean = clearMetadata(directory_path)
    clean.unZipFiles()
    clean.findFiles()
    clean.cleanFiles()

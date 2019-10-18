import os
import shutil
import zipfile
import lxml
import csv
import xlrd
import pandas as pd


class clearMetadata:

    # Initialize variables
    def __init__(self, directory_path):
        self.excel_ext = ['.xlsx', '.xls']
        self.word_ext = ['.docx', '.doc']
        self.dpath = directory_path
        self.clear_ext = ['.pdf'] + self.excel_ext + self.word_ext
        self.clean_list = []
        self.current_dir = os.getcwd()

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
                    self.clean_list.append(file)

    # Clear metadata by re-writing or printing as pdf
    def cleanFiles(self):
        for file in self.clean_list:
            file_basename, file_ext = os.path.splitext(os.path.basename(file))

            # Clean the excel file by converting to csv
            if file_ext in self.excel_ext:
                print(f'Converting "{file}" to a .csv file')
                excel = pd.ExcelFile(file)
                sheet_names = excel.sheet_names
                for sheet in sheet_names:
                    excel_data = excel.parse(sheet)
                    if not excel_data.empty:
                        csv_file = file_basename + '_' + sheet + '.csv'
                        excel_data.to_csv(csv_file, sep=',', encoding='utf-8', index=False)

            # Clean word file by printing to pdf
            if file_ext in self.word_ext:
                pdf_file = file_basename + '_wordconvert.PDF'



# Run the cleaner
if __name__ == '__main__':
    # Specify directory which you want to search
    directory_path = r'C:\Python\SeniorAE\scratch\metadata\AE483_Lab2_Materials'

    # Clean files
    clean = clearMetadata(directory_path)
    clean.unZipFiles()
    clean.findFiles()
    clean.cleanFiles()

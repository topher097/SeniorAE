import os
import zipfile
import pandas as pd
import time
import shutil
import docx2txt


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
        self.root = ''
        self.file_basename = ''
        self.file_ext = ''
        self.file = ''
        self.info_text = ''
        self.legpath = os.path.join(self.current_dir, r'AE483_Lab2_Materials_LEGACY.zip')

    # Initialize test folder from legacy (for testing purposes, unzip folder)
    def initialize(self):
        try:
            shutil.rmtree(self.dpath)
        except Exception:
            print('cannot remove folder')
            pass
        with zipfile.ZipFile(self.legpath, 'r') as zip_ref:
            zip_ref.extractall(self.current_dir)
        os.rename(os.path.basename(self.legpath).replace('.zip', ''), os.path.basename(self.dpath))

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
                print_string = f'Un-zipped {item}'
                self.info_text += str(print_string) + '\n'
                print(print_string)

    # Find the files which may contain metadata, store path to file in a list
    def findFiles(self):
        for root, dpath, files in os.walk(self.dpath):
            for file in files:
                file_basename, file_extension = os.path.splitext(os.path.basename(file))
                if file_extension in self.clear_ext:
                    print_string = f'"{file}" may have metadata'
                    print(print_string)
                    self.info_text += str(print_string + '\n')
                    file_full_path = os.path.join(root, file)
                    self.clean_list.append(file_full_path)

    # Clean file based on extension
    def cleanFiles(self):
        self.info_text += '\n\nMetrics:\n'
        for file in self.clean_list:
            self.file = file
            self.file_basename, self.file_ext = os.path.splitext(os.path.basename(file))
            self.root = os.path.dirname(file)

            # Clean the excel file by converting to csv
            if self.file_ext in self.excel_ext:
                clearMetadata.cleanExcel(self)
            # Clean the word file by saving as PDF
            if self.file_ext in self.word_ext:
                clearMetadata.cleanWord(self)

    # Clean word files by converting to a txt file.
    def cleanWord(self):
        error_string = ''
        try:
            self.word_counter += 1
            start_time = time.time()

            # Create directory to save the docx stuff to (images, hyperlinks, etc.)
            image_folder = os.path.join(self.root, self.file_basename + f'_images{self.word_counter}')
            if os.path.exists(image_folder):
                try:
                    os.remove(image_folder)
                except Exception as error:
                    error_string = error_string + str(error)
                    pass
            else:
                try:
                    os.makedirs(image_folder)
                except Exception as error:
                    error_string = error_string + str(error)
                    pass
            try:
                text = docx2txt.process(self.file, image_folder)          # Get the data from docx file
            except Exception as error:
                error_string = error_string + str(error)
                text = ''
                pass

            # Create the text file
            new_file_name = os.path.join(self.root, self.file_basename + f'_converted{self.word_counter}.txt')

            with open(new_file_name, 'wt') as textfile:
                textfile.write(text)

            os.remove(self.file)
            end_time = time.time()
            total_time = end_time - start_time
            print_string = f'Converted "{self.file_basename + self.file_ext}" to "{os.path.basename(new_file_name)}" ' \
                           f'in {round(total_time * 1000, 4)} ms'
            print(print_string)
            self.info_text += str(print_string + '\n')
        except Exception as e:
            error_string = error_string + str(e)
            print_string = f'Cound not clean "{self.file_basename + self.file_ext}", error: {str(error_string)}, removed file'
            os.remove(self.file)
            print(print_string)
            self.info_text += '*' + str(print_string) + '\n'

    # Clean Excel file by converting to csv file(s)
    def cleanExcel(self):
        try:
            self.excel_counter += 1
            excel = pd.ExcelFile(self.file)                                     # Open Excel file
            sheet_names = excel.sheet_names                                     # Get list of names of sheets
            for sheet in sheet_names:
                start_time = time.time()
                excel_data = excel.parse(sheet)                                 # Parse Excel data
                if not excel_data.empty:
                    csv_file = self.file_basename + '_' + sheet + f'_{self.excel_counter}.csv'
                    csv_path = os.path.join(self.root, csv_file)
                    excel_data.to_csv(csv_path, sep=',', encoding='utf-8', index=False)
                    end_time = time.time()
                    total_time = end_time - start_time
                    print_string = f'Converted "{self.file_basename + self.file_ext}" to "{csv_file}" in ' \
                                   f'{round(total_time * 1000, 4)} ms'
                    print(print_string)
                    self.info_text += str(print_string + '\n')
            os.remove(self.file)
        except Exception as e:
            print_string = f'Cound not clean "{self.file_basename + self.file_ext}", error: {str(e)}, removed file'
            os.remove(self.file)
            print(print_string)
            self.info_text += '*' + str(print_string) + '\n'

    # Write the info file for reviewers/diagnostics
    def writeInfoFile(self):
        info_file_name = '000_CLEAN_INFO.txt'
        with open(os.path.join(self.dpath, info_file_name), 'wt') as text:
            text.write(self.info_text)
        text.close()


# Run the cleaner
if __name__ == '__main__':
    # Specify directory which you want to search
    directory_path = r'C:\Python\SeniorAE\scratch\metadata\AE483_Lab2_Materials'

    # Clean files
    clean = clearMetadata(directory_path)
    clean.initialize()
    clean.unZipFiles()
    clean.findFiles()
    clean.cleanFiles()
    clean.writeInfoFile()


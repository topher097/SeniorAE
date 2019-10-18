import os
import shutil
import zipfile


class clearMetadata:

    # Initialize variables
    def __init__(self, directory_path):
        self.dpath = directory_path
        self.clear_ext = ['.docx', '.xlsx', '.pdf']
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
                #print(os.path.join(root, file))
                file_basename, file_extension = os.path.splitext(os.path.basename(file))
                if file_extension in self.clear_ext:
                    print(f'{file_basename} may have metadata')
                    self.clean_list.append(file)

    # Clear metadata by copying files (rename with '_COPY')
    def cleanFiles(self):
        for file in self.clean_list:
            file_path = os.path.dirname(file)
            file_basename, file_ext = os.path.splitext(os.path.basename(file))
            new_file_name = file_basename + r'_COPY' + file_ext
            shutil.copyfile(file, os.path.join(file_path, new_file_name))


# Run the cleaner
if __name__ == '__main__':
    # Specify directory which you want to search
    directory_path = r'C:\Users\TOPHER-LAPTOP\Desktop\Test_Scripts\AE483_Lab2_Materials'

    clean = clearMetadata(directory_path)
    clean.unZipFiles()
    clean.findFiles()
    clean.cleanFiles()
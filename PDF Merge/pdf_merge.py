from PyPDF2 import PdfFileMerger
import shutil
import os
import sys


class pdfMerger():
    def __init__(self):
        self.merger = PdfFileMerger()
        self.input_dir = os.path.join(os.getcwd(), 'Input Files\\')
        self.input_names = []
        self.input_names_sorted = []
        self.input_locs_sorted = []
        self.output_dir = os.path.join(os.getcwd(), 'Output\\')
        self.output_name = ''
        self.output_loc = os.path.join(self.output_dir, self.output_name)

        # Get input file order and output file name from dialogue box
        pdfMerger.parameters(self)
        # Merge files into output file
        pdfMerger.mergePDF(self)
        # Check to see if input folder should be cleared
        pdfMerger.clearInput(self)

    def parameters(self):
        # Create list of files in the input folder
        self.input_names = [f for f in os.listdir(self.input_dir) if os.path.isfile(os.path.join(self.input_dir, f)) and 'pdf' in f.lower()]
        # Check if number of files is more than one
        if len(self.input_names) <= 1:
            print('Not enough files in the input file folder...')
            sys.exit()
        # Get input string
        valid_input = False
        while not valid_input:
            # Check if number of files is more than one
            file_order_string = pdfMerger.getInput(self)
            # Check if string is valid
            if file_order_string.isdigit():
                file_order_list = [int(f) for f in file_order_string]
                num_higher = False
                for ele in file_order_list:
                    if ele >= len(self.input_names)+1:
                        num_higher = True
                        break
                if not num_higher:
                    # Sort the files given input
                    for ele in file_order_list:
                        self.input_names_sorted.append(self.input_names[ele-1])
                    valid_input = True
                else:
                    pdfMerger.printError(self)
            else:
                pdfMerger.printError(self)
        output_name_text = '-'*30 + '\nOutput file name (no .pdf extension):\n'
        self.output_name = input(output_name_text) + '.pdf'
        self.output_loc = os.path.join(self.output_dir, self.output_name)

    def printError(self):
        print('-' * 30)
        print('Invalid input, please input again...')

    def getInput(self):
        # Get input of order, syntax of '12345', where 1 is the number of the first file in list, 2 is second, etc
        input_text = f'Pick order of merge:\n'
        for file in self.input_names:
            input_text += f'{self.input_names.index(file) + 1}. {file}\n'
        file_order_string = input(input_text)
        return file_order_string

    def mergePDF(self):
        info_text = '-'*30 + '\nMerging input files in order:\n'
        for file in self.input_names_sorted:
            info_text += f'{self.input_names_sorted.index(file) + 1}. {file}\n'
            self.input_locs_sorted.append(os.path.join(self.input_dir, file))
        info_text += f'Into: {self.output_name}\n'
        print(info_text)
        for pdf in self.input_locs_sorted:
            self.merger.append(pdf)
        self.merger.write(self.output_loc)
        self.merger.close()

    def clearInput(self):
        clear_text = 'Clear the input files? (y or n)\n'
        if input(clear_text).lower() == 'y':
            for filename in os.listdir(self.input_dir):
                file_path = os.path.join(self.input_dir, filename)
                try:
                    if os.path.isfile(file_path) or os.path.islink(file_path):
                        os.unlink(file_path)
                    elif os.path.isdir(file_path):
                        shutil.rmtree(file_path)
                    print(f'Cleared: {filename}')
                except Exception as e:
                    print('Failed to delete %s. Reason: %s' % (file_path, e))
        else:
            pass


if __name__ == '__main__':
    # Initialize the output file
    try:
        shutil.rmtree(os.path.join(os.getcwd(), 'Output\\'))
    except Exception as e:
        print(f'Could not remove output folder, error: {str(e)}')
    try:
        os.mkdir(os.path.join(os.getcwd(), 'Output\\'))
    except Exception as e:
        print(f'Could not create output folder, error: {str(e)}')

    # Run merger
    pdf = pdfMerger()

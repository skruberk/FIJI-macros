from ij import IJ, WindowManager
from ij.io import DirectoryChooser
from java.io import File
from loci.plugins import BF
from loci.plugins.in import ImporterOptions
import os
import re

# Define input and output directories
input_dir = DirectoryChooser("Choose an input directory").getDirectory()
output_dir = DirectoryChooser("Choose an output directory").getDirectory()

if input_dir and output_dir:
    # Function to process each file or subfolder
    def processFolder(input_dir):
        list_files = os.listdir(input_dir)
        for file_name in list_files:
            if file_name.endswith(".dv"):
                processFile(input_dir, output_dir, file_name)
            elif os.path.isdir(os.path.join(input_dir, file_name)) and not re.search(output_dir, file_name):
                processFolder(os.path.join(input_dir, file_name))
            else:
                print("Skipping non-dv file or subfolder:", file_name)

    # Function to process each file
    def processFile(input_dir, output_dir, file_name):
        # Set Bio-Formats options to suppress dialogs
        options = ImporterOptions()
        options.setQuiet(True)
        options.setId(os.path.join(input_dir, file_name))

        # Open the image using Bio-Formats
        imps = BF.openImagePlus(options)

        if imps:
            for imp in imps:
                imp.show()
                title = imp.getTitle()
                title2 = File(title).getName().split(".")[0]  # Get filename without extension
                output_path = output_dir
                File(output_path).mkdirs()  # Create output directory if it doesn't exist

                # Example: Save each channel as TIFF
                IJ.run(imp, "Split Channels", "")
                for ch in range(1, imp.getNChannels() + 1):
                    imp.setC(ch)
                    filename = "C{}-{}.tif".format(ch, title2)
                    IJ.saveAs(imp, "Tiff", os.path.join(output_path, filename))

                imp.close()

    # Start processing from the input directory
    processFolder(input_dir)

IJ.run("Close All");

  
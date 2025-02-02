input = getDirectory("Choose an input directory");
output = getDirectory("Choose an output directory");

processFolder(input);

function processFolder(input) {
    list = getFileList(input);
    for (i = 0; i < list.length; i++) {
        if (endsWith(list[i], ".tif")) { // Process only . files put .ometiff here or whatever the extension is
            processFile(input, output, list[i]);
        } else if (endsWith(list[i], "/") && !matches(output, ".*" + substring(list[i], 0, lengthOf(list[i]) - 1) + ".*")) {
            // Recursively process subfolders
            processFolder("" + input + list[i]);
        } else {
            // Log for files
            print("Skipping: " + input + list[i]);
        }
    }
}

function processFile(input, output, file) {
    extension = substring(file, lastIndexOf(file, ".") + 1, lengthOf(file));
    // Open the file using Bio-Formats Importer you can match your settings here
    run("Bio-Formats Importer", "open=[" + input + file + "] color_mode=Default open_files open_all_series rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
	// Define the correct output file path
    outputFilePath = output + file; //  join paths
	 // Save as TIFF
    saveAs("Tiff", outputFilePath);
    // Close the image
    close();

    print("Processed and compressed: " + outputFilePath);
}



// Close all open images and reset
//run("Close All");
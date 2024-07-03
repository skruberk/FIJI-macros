input = getDirectory("Choose an input directory");
output = getDirectory("Choose an output directory");

processFolder(input);

function processFolder(input) {
    list = getFileList(input);
    for (i = 0; i < list.length; i++) {
        if (endsWith(list[i], ".dv")) { // pick all files with .dv extension, replace this for other extensions
            processFile(input, output, list[i]);
        } else if (endsWith(list[i], "/") && !matches(output, ".*" + substring(list[i], 0, lengthOf(list[i]) - 1) + ".*")) {
            // if the file encountered is a subfolder, go inside and run the whole process in the subfolder
            processFolder("" + input + list[i]);
        } else {
            // if the file encountered is not an image nor a folder just print the name in the log window
            print(input + list[i]);
        }
    }
}

function processFile(input, output, file) {
    // Disable Bio-Formats Importer dialog
    setBatchMode(true);
    run("Bio-Formats Importer", "open=[" + input + file + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
    
    title = getTitle();
    title2 = substring(title, 0, lastIndexOf(title, "."));
    
    run("Split Channels");
    two = "C2-" + title;
    one = "C1-" + title;
    
    selectWindow("C2-" + title);
    saveAs("tiff", output + File.separator + "C2-" + title2 + ".tif");
    
    selectWindow("C1-" + title);
    saveAs("tiff", output + File.separator + "C1-" + title2 + ".tif");
    
    print(output);
    close();
    setBatchMode(false);
}

// setBatchMode(false);
run("Close All");

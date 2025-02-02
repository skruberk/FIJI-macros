// Fiji Macro to save all open images
// Prompts user for a save directory

// Ask user to choose a save directory
saveDir = getDirectory("Choose a directory to save images");
if (saveDir == "") exit("No directory chosen. Script canceled.");

// Get list of all open images
imageCount = nImages;
if (imageCount == 0) exit("No images open.");

for (i = 1; i <= imageCount; i++) {
    selectImage(i);
    title = getTitle();
    path = saveDir + title;
    if (!endsWith(title, ".tif")) {
        path += ".tif"; // Save as TIFF by default
    }
    saveAs("Tiff", path);
}

print("Saved " + imageCount + " images to " + saveDir);

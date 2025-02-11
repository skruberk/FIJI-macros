// Get the currently active image (assumes it's a time-lapse series)
// Get the active image
id = getImageID();
// Get the number of slices (works for both Z-stacks and time-series stacks)

nSlice = nSlices();


// Define the parameters for intensity measurement
startFrame = 1;  // Start at the first frame
endFrame = nSlice; // Last frame
roiCount = roiManager("count");
// Create a 2D array to store mean intensities [ROI index][Frame index]
intensities = newArray(roiCount, nSlices);


// Loop over each frame in the stack
for (i = 1; i <= nSlices; i++) {
    setSlice(i);  // Set the current frame

    // Measure intensity within the manually drawn ROI
    run("Measure");

    // Store the mean intensity value from the results table
    intensities[i-1] = getResult("Mean", nResults()-1);
}

print("Mean intensities per frame within the ROI:");
for (i = 0; i < nSlices; i++) {
    print("Frame " + (i+1) + ": " + intensities[i]);
}
// Create a plot to visualize the mean intensity change over time

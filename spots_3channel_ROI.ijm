//remove comment from below to pull from OMERO
//run("Connect to OMERO");
//waitForUser("Waiting for user to select file. Press Okay to continue....");

orgName =getTitle();
orgNameTRIM = replace(orgName, ".tif.*", "");
output_path = getDirectory("Choose output folder"); 
fileList = getFileList(output_path); 


//run("Channels Tool...");
Stack.setChannel(1);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(3);
run("Enhance Contrast", "saturated=0.35");
Stack.setChannel(2);
run("Enhance Contrast", "saturated=0.35");

waitForUser("Draw some ROIs - press 't' to add them");

numROIs = roiManager("count");


for(i=0; i<numROIs;i++) // loop through ROIs
	{ 
	roiManager("Select", i);
  


//run("Spot Intensity In All Channel", "detection=5 noise=100 measurement=5 background=5 treat");
run("Spot Intensity In All Channel", "detection=5 noise=100 measurement=5 background=5");

//waitForUser("wait for window");

//Saving Results to a .csv
selectWindow("Spot analysis of " + orgNameTRIM);
saveAs("Results", output_path + orgName + i + ".csv");
close("*.csv");
  }
  
roiManager("Save",output_path + orgName + ".zip");
roiManager("Deselect");
roiManager("Delete");
close("*");

//based on 16bit tif, 2 channels
input = getDirectory("Choose a Directory");
output = getDirectory("select or create destination directory");
suffix = ".tif";

function action(input, output, filename) {

open(input + filename);

Stack.setChannel(1);												                   	// SELECT CHANNEL OF INTEREST
run("Cyan");														                        // RUN COMMAND
//run("Enhance Contrast", "saturated=0.20");										// RUN COMMAND
setMinAndMax(0, 32000);										                			// RUN COMMAND
Stack.setChannel(2);											                  		// SELECT CHANNEL OF INTEREST
setMinAndMax(0, 6000);
run("Yellow");
                                saveAs("tiff",output+getTitle());
                        close();
}

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)	
if(endsWith(list[i], suffix))  											           	 // process only .tif
action(input, output, list[i]);
setBatchMode(false);

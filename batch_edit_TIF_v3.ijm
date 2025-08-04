//drblot 07-2025
//batch process, recolour, set Min/Max for a directory of .tif

input = getDirectory("Choose a Directory");
output = getDirectory("select or create destination directory");
suffix = ".tif";

function action(input, output, filename) {

run ("Bio-Formats Macro Extensions");
Ext.openImagePlus(input + filename);
fname = getTitle();

Stack.setChannel(1);												                   	// SELECT CHANNEL OF INTEREST
run("Yellow");													                      	// RUN COMMAND
//run("Enhance Contrast", "saturated=0.20");										// RUN COMMAND
setMinAndMax(400, 5000);													              // RUN COMMAND

Stack.setChannel(2);													
setMinAndMax(1000, 15000);
run("Cyan");

Stack.setChannel(3);													
setMinAndMax(200, 10000);
run("Magenta");

Stack.setChannel(4);												
setMinAndMax(400, 1200);
run("Grays");

Stack.setDisplayMode("composite");
Stack.setActiveChannels("1101");										            //turn off chan3

                                saveAs("tiff",output+fname);
                        close();
}

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)	
if(endsWith(list[i], suffix))  											          	 //process only .tif
action(input, output, list[i]);
setBatchMode(false);

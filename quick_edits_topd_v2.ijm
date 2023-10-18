
input = getDirectory("Choose a Directory");
output = getDirectory("select or create destination directory");
suffix = ".tif";

function action(input, output, filename) {

//open (input + filename);
//open runs bioformats in linx and breaks automation wihout the below fix

run ("Bio-Formats Macro Extensions");
Ext.openImagePlus(input + filename);
fname = getTitle();

Stack.setChannel(1);													// SELECT CHANNEL OF INTEREST
run("Cyan");														// RUN COMMAND
//run("Enhance Contrast", "saturated=0.20");										// RUN COMMAND
setMinAndMax(0, 32000);													// RUN COMMAND
Stack.setChannel(2);													// SELECT CHANNEL OF INTEREST
setMinAndMax(0, 6000);
run("Yellow");
Stack.setChannel(3);													// SELECT CHANNEL OF INTEREST
setMinAndMax(0, 6000);
run("Magenta");
Stack.setChannel(4);													// SELECT CHANNEL OF INTEREST
setMinAndMax(0, 12000);
run("Grays");
Stack.setActiveChannels("1110");										//turn off chan4

                                saveAs("tiff",output+fname);
                        close();
}

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)	
if(endsWith(list[i], suffix))  												 //process only .tif
action(input, output, list[i]);
setBatchMode(false);


input = getDirectory("Choose a Directory");
output = getDirectory("select or create destination directory");

function action(input, output, filename) {

open(input + filename);

Stack.setChannel(1);													// SELECT CHANNEL OF INTEREST
run("Grays");															// RUN COMMAND
run("Enhance Contrast", "saturated=0.20");								// RUN COMMAND
Stack.setChannel(2);													// SELECT CHANNEL OF INTEREST
run("Enhance Contrast", "saturated=0.35");								// RUN COMMAND

                                saveAs("tiff",output+getTitle());
                        close();
}

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
action(input, output, list[i]);
setBatchMode(false);
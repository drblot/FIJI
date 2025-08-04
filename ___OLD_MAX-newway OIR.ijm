input = getDirectory("Choose a Directory");
output = getDirectory("select or create destination directory");

function action(input, output, filename) {

run("Bio-Formats Importer", "open=["+ input + filename +"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");

 run("Z Project...", "projection=[Max Intensity]");
                                saveAs("tiff",output+getTitle());
                        close();


close();
}

setBatchMode(true); 
list = getFileList(input);
for (i = 0; i < list.length; i++)
action(input, output, list[i]);
setBatchMode(false);

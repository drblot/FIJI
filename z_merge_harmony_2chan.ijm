// based on an old macro and https://forum.image.sc/t/batch-merging-macro-on-fiji/51727/6
// for harmony exported .TIFF
// change for other formats 

macro "Merge harmony files" { //start of macro
dir1 = getDirectory("Source");
dir2 = getDirectory("Destination");

list = getFileList(dir1);
Array.sort(list);
setBatchMode(true);

// Create the arrays first
chan1 = newArray(0);
chan2 = newArray(0);


// Get the blue green and gray channel names
for (i = 0; i < list.length; i++) {
   file = list[i];
   if (startsWith(file, "r")) {
      if (endsWith(file, "ch1sk1fk1fl1.tiff")) {						// change here
         chan1 = Array.concat(chan1, file); 
      } else if (endsWith(file, "ch2sk1fk1fl1.tiff")) { 				// change here
         chan2 = Array.concat(chan2, file); 
      }
   } 
}

//print(chan1.length);
//print(chan2.length);

// A safeguard. If one channel image is missing, we would fail somewhere
if (chan1.length != chan2.length) {
   exit("Unequal number of blue and gray channels found");
}

// Loop over the images
for (i = 0; i < chan1.length; i++) {
   Channel1 = chan1[i];
   Channel2 = chan2[i];
   open(dir1+Channel1);
   run("Grays");
//   enhance(getImageID());
   open(dir1+Channel2);
   run("Green");
//   enhance(getImageID());
   // Using the "&" string expansion option within command arguments
   run("Merge Channels...", "c3=&Channel1 c4=&Channel2 create");
   fileName = substring(Channel1, 0, lastIndexOf(Channel1, "ch1sk1fk1fl1.tiff"))+"_Composite";
   saveAs("tiff", dir2 + fileName);
   close();
}

// All common image processing tasks in here
function enhance(imageID) {
   selectImage(imageID);
   run("Enhance Contrast", "saturated=0.35");
   run("Apply LUT");
}

setBatchMode(false);
print("Done");
}

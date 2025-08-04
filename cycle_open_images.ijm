//Alex M Sykes 07-2025

n = nImages;
print(n);
for (i=0;i<nImages;i++)
 {
selectImage(i+1);

//-------------------------
// start of macro
Stack.setDisplayMode("composite");
Stack.setActiveChannels("10000");            // set channel 1 to active only

// end of macro;
//----------------------------
}
run("Tile");

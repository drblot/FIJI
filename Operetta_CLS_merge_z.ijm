// merge Operetta CLS z planes per field
// Alex M Sykes 06-2026

setBatchMode(true);

inputDir = getDirectory("Choose folder");
outputDir = getDirectory("Choose folder");
suffix = ".tiff";

list = getFileList(inputDir);

// Find unique field IDs (rXXcXXfXX)
bases = newArray();

for (i=0; i<list.length; i++) {
    name = list[i];

    if (!endsWith(name, suffix))
        continue;

    parts = split(name, "p");
    base = parts[0];      // r01c01f01

    found = false;
    for (j=0; j<bases.length; j++)
        if (bases[j] == base)
            found = true;

    if (!found)
        bases = Array.concat(bases, base);
}

for (b=0; b<bases.length; b++) {

    base = bases[b];
    print("Processing " + base);

    channelNames = newArray();

    for (ch=1; ch<=8; ch++) {

        files = newArray();

        for (i=0; i<list.length; i++) {

            name = list[i];

            if (startsWith(name, base+"p") &&
                indexOf(name, "-ch"+ch) >= 0)
                files = Array.concat(files, name);
        }

        if (files.length == 0)
            continue;

        Array.sort(files);

        // Open first image
        open(inputDir + files[0]);

        for (k=1; k<files.length; k++) {
            open(inputDir + files[k]);
        }

        run("Images to Stack", "name=C"+ch+" title=[] use");

        rename("C"+ch);

        channelNames = Array.concat(channelNames, "C"+ch);
    }

    if (channelNames.length == 0)
        continue;

    cmd = "";

    for (c=0; c<channelNames.length; c++)
        cmd += "c"+(c+1)+"="+channelNames[c]+" ";

    run("Merge Channels...", cmd+"create");

    Stack.setDisplayMode("composite");

    saveAs("Tiff", outputDir + base + ".tif");

    close("*");
}

setBatchMode(false);

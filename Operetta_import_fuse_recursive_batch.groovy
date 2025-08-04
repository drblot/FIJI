//operetta import and fuse
// opens all "Images/" directories from parent folder
//   parent_folder/operetta1/Images
//   parent_folder/operetta2/Images
//   etc
//Alex M Sykes 07 2025


import ch.epfl.biop.operetta.OperettaManager
import ij.IJ

#@ File id (label="Location of Index.idx.xml File", style="directory")
#@ File saveDir (label="Save Location", style="directory")
#@ Integer downsample (label="Downsample Factor", value=4)

// Get all subdirectories
def directories = id.listFiles().findAll { it.isDirectory() }

// Append "/images" to each directory
def imageDirs = directories.collect { new File(it, "Images/") }

// Loop over each images directory
imageDirs.each { imagesDir ->

// Make sure the directory exists and contains files
    if (imagesDir.exists() && imagesDir.isDirectory()) {
def indexFile = new File(imagesDir, "Index.idx.xml")
//        def indexFile = new File(imagesDir.parentFile, "Index.idx.xml")
        if (!indexFile.exists()) {
            println "Skipping ${imagesDir.path}, Index.idx.xml not found."
            return
        }

        def opm = new OperettaManager.Builder()
                        .setId(indexFile)
                        .fuseFields(true)
                        .useStitcher(true)
                        .setDownsample(downsample)
                        .build()

        def allWells = opm.getWells()

        allWells.each { well ->
            def wellImage = opm.getWellImage(well)
            def imageName = opm.getWellImageName(well)
            def outFile = new File(saveDir, "${imageName}.tif")
            IJ.saveAsTiff(wellImage, outFile.absolutePath)
        }

        println "Processed: ${imagesDir.path}"
    }
}

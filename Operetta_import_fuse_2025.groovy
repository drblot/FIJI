//operetta import and fuse JULY 2025
//downsample factor set to 4
//fuse set to true

#@ File id (label="Location of Index.idx.xml File", style="directory")
#@ File saveDir (label="Save Location", style="directory")


import ch.epfl.biop.operetta.OperettaManager
import ij.IJ

def opm = new OperettaManager.Builder()
									.setId( new File( id, "Index.idx.xml" ) )
									.fuseFields(true)
									.useStitcher(true)
        					.setDownsample(4)
									//.coordinatesCorrectionFactor( correctionFactor )
									.build()

def allWells = opm.getWells( )

// Process all wells
allWells.each{ well ->
    def wellImage = opm.getWellImage( well )
    def imageName = opm.getWellImageName( well)
    IJ.saveAsTiff( wellImage, new File( saveDir, imageName + "_fused" ).getAbsolutePath() );
}
	
	IJ.log("FIN"); 

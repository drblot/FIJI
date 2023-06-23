//operetta import and fuse

#@ File id (label="Location of Index.idx.xml File", style="directory")
#@ File saveDir (label="Save Location", style="directory")
#@ Integer downsample (label="Downsample Factor", value=10)
#@ Double correctionFactor (label="Correction Factor", value=0.995)


import ch.epfl.biop.operetta.OperettaManager
import ij.IJ

def opm = new OperettaManager.Builder()
									.setId( new File( id, "Index.idx.xml" ) )
									.coordinatesCorrectionFactor( correctionFactor )
									.build()

def allWells = opm.getAvailableWells()                                                         //  .take(1)

allWells.each{ well ->
	def allFields = opm.getAvailableFields( well )                                         //  .take(10)
	
	allFields.each { field ->
		def fieldImage = opm.getFieldImage( field, downsample )
		IJ.saveAsTiff( fieldImage , new File( saveDir, fieldImage.getTitle() ).getAbsolutePath() )
	}

	// Save positions file
	opm.writeWellPositionsFile( allFields, new File( saveDir, opm.getFinalWellImageName( well ) + ".txt" ), downsample )

	// Run Grid/Collection Stitching on the saved images. Here we just use it naively from the coordinates, just to show that it works
	IJ.run("Grid/Collection stitching", 
	"type=[Positions from file] order=[Defined by TileConfiguration] directory=["+saveDir.getAbsolutePath()+"] layout_file=["+opm.getFinalWellImageName( well ) + ".txt"+"] fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 add_tiles_as_rois computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	
	// Save fused image
	IJ.run("Remove Overlay");
	imp = IJ.getImage();

	IJ.saveAsTiff( imp, new File( saveDir, opm.getFinalWellImageName( well ) + "_fused" ).getAbsolutePath() );
	imp.close();
		IJ.log("Fused image Saved");
	}

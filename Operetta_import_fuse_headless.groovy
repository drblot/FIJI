//operetta import and fuse
//based on https://forum.image.sc/t/stitching-operetta-images-with-biop-script-1-pixel-black-border-around-each-tile/82684


//input directory
def id = new File ("/path/to/input/")
//output directory
def saveDir = new File( "/path/to/output/" )
//downsample factor
def int downsample = 2
//correction factor
def double correctionFactor = 0.995

import ch.epfl.biop.operetta.OperettaManager
import ij.IJ

def opm = new OperettaManager.Builder()
									.setId( new File( id, "Index.idx.xml" ) )
									.coordinatesCorrectionFactor( correctionFactor )
									.build()

def allWells = opm.getAvailableWells()                                                     //  .take(1)

allWells.each{ well ->
	def allFields = opm.getAvailableFields( well )                                         //  .take(10)
	
	allFields.each { field ->
		def fieldImage = opm.getFieldImage( field, downsample )
		IJ.saveAsTiff( fieldImage , new File( saveDir, fieldImage.getTitle() ).getAbsolutePath() )
	}

	// Save positions file
	opm.writeWellPositionsFile( allFields, new File( saveDir, opm.getFinalWellImageName( well ) + ".txt" ), downsample )

	// Run Grid/Collection Stitching on the saved images
	IJ.run("Grid/Collection stitching", 
	"type=[Positions from file] order=[Defined by TileConfiguration] directory=["+saveDir.getAbsolutePath()+"] layout_file=["+opm.getFinalWellImageName( well ) + ".txt"+"] fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 add_tiles_as_rois computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
	
	// Save fused image
	IJ.run("Remove Overlay");
	imp = IJ.getImage();
	
	IJ.saveAsTiff( imp, new File( saveDir, opm.getFinalWellImageName( well ) + "_fused" ).getAbsolutePath() );
	imp.close();
	IJ.log("Fused image Saved");
	}
	
	IJ.log("FIN"); 

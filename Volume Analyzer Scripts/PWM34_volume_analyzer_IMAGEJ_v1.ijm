//Plant Water Management: Volume Analyzer
//version 1.0
//9/10/21


//User prompts dialog box:
samplef = 1; //process every nth frame
numpts = 30; //number of points within each frame
filetype = ".tif";

Dialog.create("Volume Analyzer");
Dialog.addNumber("Sample every n frames (choose 1 if fps selected in ffmpeg):", samplef);
Dialog.addNumber("Number of sample points within each frame:", numpts);
Dialog.addString("Type of image file (include dot):", filetype);
Dialog.addMessage("Click OK, then elect the first file of the sequence.");
Dialog.show();

//Update parameters with user choices:
samplef = Dialog.getNumber();
numpts = Dialog.getNumber();
filetype = Dialog.getString();

//Determine file location and save location/directory as variables:
path = File.openDialog("Select a File:");
  //open(path); // open the file
dir = File.getParent(path);
//name = File.getName(path);
fileList = getFileList(dir);
numFiles = lengthOf(fileList);

//Open the first file... temporarily for make directory purposes (hacky)
open(path);

// Create two directories in current location
myDir1 = File.directory+"Composites_Output"+File.separator;
myDir2 = File.directory+"Results_Output"+File.separator;
  File.makeDirectory(myDir1);
  File.makeDirectory(myDir2);
  if (!File.exists(myDir1))
      exit("Unable to create directory");
  if(!File.exists(myDir2))
  	  exit("Unable to create directory");

close("*"); //Close first image

run("Set Measurements...", "invert redirect=None decimal=3"); //Sets 0,0 to bottom left corner

//Start Outer Loop

for(k=0; k<lengthOf(fileList); k+=samplef){
//for(k=0; k<1; k+=samplef){
		
	name = fileList[k];
	open(name);
	
	//Prep for image processing: remove name suffix, determine where sample points go, etc.
	suffixindex = indexOf(name, filetype);
	subname = substring(name, 0, suffixindex);
	width = getWidth;
	height = getHeight;
	p = numpts; //number of points
	n = p+1; //fencepost issue quickfix
	dn = (width/n);
	
	//Image Thresholding
	run("8-bit"); 
	run("Duplicate...", subname);
	setRGBWeights(0, 1, 0); //use only green channel because fluid is red
	run("8-bit"); //convert to greyscale
	
	setAutoThreshold("Default");
	//setThreshold(0, 162); //threshold values from manual test... failed, lets try auto
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Fill Holes");
	run("Outline");
	
	
	//Inner Loop (processes each file and creates a .txt file with the results)
	for (i = 1; i < n; i++) {
		a = floor(i*dn); //works like round-down
		b = 0;
		while (getPixel(a,b) == 0 && b < height) {
			b += 1;
			}
		makePoint(a, b);
		roiManager("add");
		}
		
	roiManager("measure");
	saveAs("Results", myDir2+subname+".txt");
	
	run("Merge Channels...", "c1="+subname+"-1"+filetype + " c4=" + name + " create");
	saveAs("tiff", myDir1+"overlay_"+subname);
	
	close();
	roiManager("reset");
	run("Clear Results");
	

}

resultList = getFileList(myDir2);
numResults = lengthOf(resultList);

print("Input folder contained " +k+ " files. Processed " +numResults + " image files. Processing complete.");



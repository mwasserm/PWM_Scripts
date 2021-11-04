
//User prompt & file location:
samplef = 30; //process every nth frame
numpts = 20; //number of points within each frame
filetype = ".jpg";

Dialog.create("Volume Analyzer");
Dialog.addNumber("Sample every n frames:", samplef);
Dialog.addNumber("Number of sample points within each frame:", numpts);
Dialog.addString("Type of image file (including dot):", filetype);
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
name = File.getName(path);

//Open the first file... temporary
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

run("Merge Channels...", "c1="+subname+"-1"+filetype + " c4=" + name + " create");
saveAs("png", myDir1+subname+"_overlay");
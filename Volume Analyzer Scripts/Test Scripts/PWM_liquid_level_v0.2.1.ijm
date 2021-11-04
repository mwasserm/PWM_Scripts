//note for v0.2: add some user interaction here - waitForUser(string) with instructions

run("Clear Results"); //remove prior results... not sure if this will cause issues 

a = getTitle();
b = indexOf(a, ".jpg");
imgname = substring(a, 0, b);
width = getWidth;
height = getHeight;
p = 10; //number of points
n = p+1; //fencepost issue quickfix
dn = (width/n);


 //***New Directory Section***
  currentdir = getDirectory("image");
  if (currentdir=="")
      exit("No temp directory available");
 
// Create a directory in current location
  myDir = currentdir+imgname+File.separator;
  File.makeDirectory(myDir);
  if (!File.exists(myDir))
      exit("Unable to create directory");
//End new directory section

//***Thresholding Section***
run("Duplicate...", imgname+"_threshold");
setRGBWeights(0, 1, 0); //use only green channel because fluid is red
run("8-bit"); //convert to greyscale

setAutoThreshold("Default");
//setThreshold(0, 162); //threshold values from manual test... failed, lets try auto
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Outline");
//End Thresholding Section


//***Section to save size of image to file***
//makePoint(width, height);
//saveAs("xy Coordinates", "/path/to//size" + ".txt");


//***Main loop***
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
saveAs("Results", myDir+"test"+".txt");

//note for v0.2: add auto save measurements to file with same name as image
//note for v0.2: maybe add macro restart option for speed
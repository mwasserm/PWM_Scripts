//note for v0.2: add some user interaction here - waitForUser(string) with instructions

run("Clear Results"); //remove prior results... not sure if this will cause issues 

name = getTitle;
width = getWidth;
height = getHeight;
p = 10; //number of points
n = p+1; //fencepost issue quickfix
dn = (width/n);

setRGBWeights(0, 1, 0); //use only green channel because fluid is red
run("8-bit"); //convert to greyscale

setAutoThreshold("Default");
//setThreshold(0, 162); //threshold values from manual test... failed, lets try auto
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Outline");

//main loop that checks pixel values in n columns starting at the top
//and working down until it finds a nonzero pixel value and adds to roiManager
//only works if Outline command worked well

//Make a point for how tall image is: 
//makePoint(0, height);
//roiManager("add");
makePoint(width, height);
saveAs("xy Coordinates", "/path/to/results/size" + ".txt");

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

//note for v0.2: add auto save measurements to file with same name as image
//note for v0.2: maybe add macro restart option for speed
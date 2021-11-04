//Quick macro to automate image sequence import & saving

//Dialog.create("FFT Image Import Macro");
//Dialog.addDirectory();

run("Input/Output...", "jpeg=85 gif=-1 file=.csv use_file copy_row save_column");

parentDir = getDirectory("Choose a Directory");

//parentDir = Dialog.getString();
dirList = getFileList(parentDir);
numFiles = lengthOf(dirList);

//Troubleshooting code only
/*
print(parentDir);
isit = File.isDirectory(parentDir);
print(isit);
print(parentDir+dirList[5]);
isit2 = File.isDirectory(parentDir+dirList[5]);
print(isit2);
*/

//Main loop

for(k=0; k<numFiles; k++){
	path = parentDir+dirList[k];
	print(path);

if (File.isDirectory(path)) {
	fileList = getFileList(path);
	
	print("Found a folder! Opening it");
	run("Image Sequence...", "open=["+path+fileList[0]+"] sort");
	
	Dialog.createNonBlocking("User Input Needed");
	Dialog.addMessage("Select a small portion of the pump head, then click OK");
	Dialog.setLocation(1000,0)
	Dialog.show()
	//maybe try "wait for user" next time
	
	run("Plot Z-axis Profile");
	Plot.getValues (xpoints, ypoints);
	
  	for (i = 0; i < xpoints.length; i++) {
    	setResult ("x", i, xpoints[i]);
    	setResult ("y", i, ypoints[i]);
 	}
  	updateResults ();

	suffixindex = indexOf(fileList[0], ".");
	subname = substring(fileList[0], 0, suffixindex);

	saveAs("Measurements", parentDir+subname+".csv");
	print("File saved as: "+parentDir+subname+".csv");
	wait(1000);
	
	run("Clear Results");
	close();
	run("Close");
}
	
}
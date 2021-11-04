 //Get open image name
a = getTitle();
b = indexOf(a, ".jpg");
imgname = substring(a, 0, b);
 
 //Get path to current directory
  currentdir = getDirectory("image");
  if (currentdir=="")
      exit("No temp directory available");
 
// Create a directory in current location
  myDir = currentdir+imgname+File.separator;
  File.makeDirectory(myDir);
  if (!File.exists(myDir))
      exit("Unable to create directory");

print(myDir);
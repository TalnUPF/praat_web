# Praat on the Web

Praat on the Web provides a web interface for Praat (http://www.fon.hum.uva.nl/praat/). It is a client server deployment of Praat, where Praat runs in the server with a web interface that allows users to upload sound files and process them with the scripts selected by the system administrator. 

The web interface does not include the full Praat functionality. e.g does not allow to run user scripts which could lead to serius security issues. 

A running example of Praat on the web can be found in http://taln.upf.edu/PraatOnTheWeb 


  
### What Praat On the Web does:

* The administrator intalls Praat On The Web and customizes the installation with: 
	- Some sample sound files (with maybe some associated input textgrids)
	- A set of scripts to run on the selected sound file (and textgrid). Scripts order can be specified in the configuration file.

* Users can select one sound file (or upload their own one), 
* Users can check and sort the scripts to run and then they can run them over the selected sound file,
* The system shows the result containing 
	- the sound file, 
	- the intensity and pitch
	- the tiers of the final textgrid.
	  
* The user can then, navigate through the sound file, check the annotations or listen the sound.
* The system uses another improvement that we did to Praat. The capacity to show multiple values (a features vector) for each interval or time point. The improvement is available in https://github.com/TalnUPF/praat/tree/upf  
  
## Specifications  

The application uses the MVC pattern with Java servlet model and is mainly developed in Java, JSP with style sheets and JavaScript. Using the following existent external libraries:
  - jQuery
  - Bootstrap
  - wavesurfer.js
  - Sortable

The project is a maven project and to generate the War file do 

>mvn package 
  
### Folder Structure

PraatWeb folder includes two subdirectories:
* src/main/java/edu/upf/taln/praat_web: contains all Java files divided in controllers, classes and utils folders
* WebContent: contains all JSP, style sheets and JavaScript files, plus several folders:
    - images: pictures used in the web
    - META-INF: the MANIFEST.MF file
    - tmp: empty folder used to temporary save the content generated via web by the users
    - WEB-INF: web.xml file
    - demos: a folder with one folder per demo, containing a configuration file each
    - demoData: Contains folders to store, sound, TextGrid files and Praat Scripts to be used in the different demos
    
# Installation

The best to do the installation is to do it using maven. Many places explain how to install maven, for example here 
 http://www.baeldung.com/install-maven-on-windows-linux-mac or the original maven page https://maven.apache.org/install.html
* Clone this repository. 
* You will also need to download Praat and define its directory in the web.xml file. You can download the source code of out extended version of Praat from here: https://github.com/TalnUPF/praat/tree/upf
* Define the demos (as explained below) and do the 
* package the war file using maven
> mvn package
* Install Tomcat  (this depends on Tomcat version and operating system, check nice tutorials out there)
* and setup (deploy) the application inside tomcat  (check some tutorials) 

## demo definition

Each demo is defined in its own folder on the demos folder, containing a JSON object (config.json) with the following information:
- Menu name
- Menu description (it can include some html)
- Demo name
- Description (it can include some html)
- Path to Folder with some sample sound files (relative to demo folder)(the folder can be empty)
- Textgrids (true/false) to indicate if the processing needs a textgrid
- Path to Folder with textgrids (relative to demo folder)(the folder can be empty)
- Path to Folder with scripts to apply at the sound file (relative to demo folder)(if empty then only intensity and pitch are computed and added to the visualitzation) when empty it can be used to display soundfiles+textgrids
- Array with scripts information. All scripts that are to be available in the demo must have their entry here. The specified fields are: file name, descriptive name, parameters taken (optional), and default order (optional). 

See the demos folder for some sample demos.
The system shows the demos in alphabetic order (so you can number the folders force the sorting like "1basic", "2advanced" , "3..."...) 

### Scripts restrictions

In order for the scripts to properly run within the application a few things must be taken into account:
- All scripts must take the same two fixed parameters at the beginning (directory and basename), additional parameters are optional.
- The intended final script on a pipeline must ensure to write the resulting Textgrid on the given directory with the given basename plus "_result.TextGrid"

See the scripts within the demos folders for some samples. 

#####################
## References and Citation
#####################

If you use this software and/or modify the code please cite the following publication:

  - Domínguez, M., I. Latorre, M. Farrús, J. Codina and L. Wanner (2016). Praat on the Web: An Upgrade of Praat for Semi-Automatic Speech Annotation.  In Proceedings of the 25th International Conference on Computational Linguistics, Osaka, Japan.


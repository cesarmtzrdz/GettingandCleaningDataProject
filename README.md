# GettingandCleaningDataProject

This project corresponds to the 4th week of the Coursera Getting and Cleaning Data Project. 
The file **run_analysis.R** performs the next steps:

	1. Download the .zip file into you working directory
	2. Unzip the file and get the catalogs for activities and columns names
	3. Get the tables for train and test
	4. merge the 3 files for each test and train into one
	5. merge the test and train files into one
	6. Subset the data with only the columns containing std() and mean()
	7. Get the mean for each subject and Activity.
	

The result of this script is a file called **hopefully_tidy.txt**, that hopefully will contain all the correct data.
Also, the script uses the library [reshape2](http://seananderson.ca/2013/10/19/reshape.html ) to facilitate the transformation of the data in the step 7.
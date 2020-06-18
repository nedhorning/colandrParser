#############################################################################
# This script reads a CSV file exported by Colandr (https://www.colandrcommunity.com/) 
# and outputs an ASCII text file with search strings using that can be pasted into the 
# Scopus “Advanced” search interface. 

# The script first extracts citations that are flagged as "citation_screening_status" = "included". 
# Next, the titles of all included citations are extracted and formatted as a Scopus 
# search string. Due to constraint in Scopus that limit the length of a search string 
# the script subsets the search string into a user-defined number of sets. For example, 
# if you had 95 citations and wanted ten titles in a single search string you would set 
# “numPapers” to ten. The output ASCII text file would have nine search strings with 10 
# titles and a tenth with five titles. 
#
# Set the variables below in the "SET VARIABLES HERE" section of the script. 
#
# This script was written by Ned Horning [horning@amnh.org] 
# Support for writing and maintaining this script comes from the CANA Foundation 
# (https://canafoundation.org/)
#
# This script is free software; you can redistribute it and/or modify it under the 
# terms of the GNU General Public License as published by the Free Software Foundation
# either version 2 of the License, or (at your option ) any later version.
#
#############################  SET VARIABLES HERE  ###################################
# Path and file name for the CSV file exported from Colandr
fileName <- "/media/ned/Data1/AMNH/Horses/Protocol/GrasslandsPast.csv"
# Output path and filename for the ASCII text file containing Scopus search strings
outFileName <- "/media/ned/Data1/AMNH/Horses/Protocol/ScopusSearchString.txt"
# Number of papers to include in a single search string
numPapers <- 10
#######################################################################################

df <- read.csv(fileName, as.is=TRUE)

# Select only included papers
df <- df[which(df[,"citation_screening_status"]=="included"),]

outLine <- paste("TITLE(\"", df[1,"citation_title"], "\"", sep="")


for (i in 2:nrow(df)) {
  if ((i %% numPapers) == 0) {
    outLine <- paste(outLine, ")", "\n\n", "TITLE(\"", df[i,"citation_title"], "\"", sep="")
  } else {
    outLine <- paste(outLine, " OR ", "\"", df[i,"citation_title"], "\"", sep="")
  }
}

outLine <- paste(outLine, ")", sep="")

fileConn<-file(outFileName)
writeLines(outLine, fileConn)
close(fileConn)




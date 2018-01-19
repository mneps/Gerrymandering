
# Gerrymandering

## Purpose
This was a small project I undertook to learn how to use the R programming language, as well as to further my own personal understanding of partisan gerrymandering in politics.  I wished to learn if there was a correlation between the extent a district had been gerrymandered and how that district voted.

## Parameters
In making this project, I took three different measurements into account: the compactness score of a district, the partisan representation of a district, and the PVI score of a district.  A distrcit's compactness score is a simple measurement--albeit a deeply imperfect one--of the scale to which a district has been gerrymandered.  To calculate a district's compactness score, simply circumscribe a circle around the district in question and divide the area of the district by the area of the circle.  The resulting decimal is that district's compactness score.  The partisan representation of a district is simple: is that district represented in the House of Representatives by a Democrat or a Republican?  The PVI score (which stands for the Partisan Voting Index) is a measurement of the strength of a district's partisan preference.  PVI scores come in three formats: D+[integer], R+[integer], and EVEN, where the D and R indicate a district leans either Democrat or Republican, respectively, with the integer representing the degree to which the district leans, in rounded percentage points.  Non-partisan districts are given an EVEN rating.

## Method
After compiling the necessary data, I placed each of the 435 districts into one of ten categories:<br />
&nbsp;&nbsp;&nbsp;Districts represented by Democrats where:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) The district leans Republican (PVI is R+\_\_)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) The district is non-partisan (PVI is EVEN)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c) The district is tepidly Democrat (PVI is D+1-5)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d) The district is moderately Democrat (PVI is D+6-15)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;e) The district is solidly Democrat (PVI is >D+15)<br />
&nbsp;&nbsp;&nbsp;Districts represented by Republicans where:<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;a) The district leans Democrat (PVI is D+\_\_)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;b) The district is non-partisan (PVI is EVEN)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c) The district is tepidly Republican (PVI is R+1-5)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;d) The district is moderately Republican (PVI is R+6-15)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;e) The district is solidly Republican (PVI is >R+15)<br />
I then took the average compactness score of all the districts that fell into each of the ten categories.  When the R script is run, two matrices will be produced.  The one described above is the first matrix.  The second matrix says how many districts were placed in each category.

## Results
Overall, compactness scores were very similar for Democrats and Republicans: the average Democratic district has a compactness score of 0.231 while the average Repbulican district's score is 0.25 (total average is 0.241).  It was interesting to note that while the compactnes scores differed from category to category by as much as nearly 15 percentage points (average compactness score for flipped Republican districts was 0.199, while for EVEN Republican districts it was 0.345) the compactness scores for corresponding Democratic and Republican categories were typically quite close (eg. average compactness score for D+1-5 districts was 0.265; for R+1-5 districts it was 0.271)

## Running the Script
To run the R script yourself, simply run
```
Rscript gerrymandering.R
```
in the terminal.  Unless the data from the two CSV files is modified, expect the program to produce the same results every time.



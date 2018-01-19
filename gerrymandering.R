#Creates the initial dataframe with state, congressional district, and
#compactness columns
create_initial_dataframe <- function()
{
	data <- read.csv(file="compactness_data.csv", head=TRUE, sep=",", 
														stringsAsFactors=FALSE)

	#alter data to make congressional districts ints
	districts <- as.numeric(gsub("\\D", "", data$"NAMELSAD"))
	for (i in 1:length(districts)) {
		if(is.na(districts[i])) {
			districts[i] <- 1
		}
	}
	#make state codes ints (these are the FIPS state codes)
	state <- as.numeric(data$"STATEFP")
	#make compactness scores ints (0 = not compact; 1 = compact)
	compactness <- as.numeric(data$"COMPACTNESS")

	#create and sort dataframe
	df <- data.frame(districts, state, compactness)
	df <- df[order(df[,2], df[,1]),]

	#data includes territories/DC as well as states. This defines the list of
	#FIPS codes for only the states.
	states <- setdiff(1:56, c(3, 7, 11, 14, 43, 52))

	#removes all non-states from the dataframe
	rows_to_remove <- c()
	for (i in 1:length(df[,2])) {
		if (!is.element(df[i,2], states)) {
			rows_to_remove <- append(rows_to_remove, i)
		}
	}
	df <- df[-rows_to_remove,]
	return (df)
}


#Adds representatives' party affiliation and PVI columns to the dataframe
add_additional_info <- function(df)
{
	partisan_data <- read.csv(file="partisan_data.csv", head=TRUE, sep=",",
														stringsAsFactors=FALSE)

	#says if the congressman is D or R
	party <- partisan_data$"Party"

	#PVI: if pvi < 0, then it's a R-leaning district; positive is D-leaning
	pvi <- c()
	for (i in 1:length(partisan_data$"PVI")) {
		if (partisan_data$"PVI"[i] == "EVEN") {
			pvi <- append(pvi, 0)
		} else {
			substring <- strsplit(partisan_data$"PVI"[i], '+', fixed=TRUE)
			if (substring[[1]][1] == "R") {
				pvi <- append(pvi, (as.numeric(substring[[1]][2])) * -1)
			} else { # == "D"
				pvi <- append(pvi, (as.numeric(substring[[1]][2])))
			}
		}
	}

	#add to the dataframe
	df$"party" <- party
	df$"pvi" <- pvi
	return (df)
}

#Returns a list of the average compactness of a district, the average
#compactness of a D district and the average compactness of a R district,
#respectively.
compactness_analysis <- function(df)
{
	dems_compactness <- c()
    gop_compactness <- c()
    for(i in 1:length(df[,4])) {
    	if (df[i,4] == "DEMOCRAT") {
    		dems_compactness <- append(dems_compactness, df[i,3])
		} else { # == "REPUBLICAN"
			gop_compactness <- append(gop_compactness, df[i,3])
		}
    }

    compactness_averages <- matrix(
    						c(mean(df[,3]), mean(dems_compactness),
    						  mean(gop_compactness)),nrow=1, ncol=3, byrow=TRUE)
    dimnames(compactness_averages) = list(c("Averages"), c("All", "Dems", "Reps"))

    return (compactness_averages)
}


#Returns a list of two matrices.  The first matrix represents the  average
#compactness of D and R districts that have PVIs of flipped (representative's
#party affiliation and PVI are not the same), even (PVI = 0), swing
#(0<|PVI|<=5), moderate (6<|PVI|<=15), and landslide (15<|PVI|), respectively.
#The second matrix has these same categories but displays how many districts
#fall in each category.
compactness_with_pvi_analysis <- function(df)
{
	dems_flipped <- c()
	dems_even <- c()
	dems_low <- c()
	dems_med <- c()
	dems_high <- c()
	gop_flipped <- c()
	gop_even <- c()
	gop_low <- c()
	gop_med <- c()
	gop_high <- c()

    for(i in 1:length(df[,4])) {
    	if (df[i,4] == "DEMOCRAT") {
    		if (df[i,5] < 0) {
    			dems_flipped <- append(dems_flipped, df[i,3])
    		} else if (df[i,5] == 0) {
    			dems_even <- append(dems_even, df[i,3])
    		} else if (df[i,5] <= 5) {
    			dems_low <- append(dems_low, df[i,3])
    		} else if (df[i,5] <= 15) {
    			dems_med <- append(dems_med, df[i,3])
			} else {
				dems_high <- append(dems_high, df[i,3])
			}
		} else { # == "REPUBLICAN"
   			if (df[i,5] > 0) {
    			gop_flipped <- append(gop_flipped, df[i,3])
	   		} else if (df[i,5] == 0) {
	    		gop_even <- append(gop_even, df[i,3])
	    	} else if (abs(df[i,5]) <= 5) {
	    		gop_low <- append(gop_low, df[i,3])
	   		} else if (abs(df[i,5]) <= 15) {
	   			gop_med <- append(gop_med, df[i,3])
			} else {
				gop_high <- append(gop_high, df[i,3])
			}
		}
	}

	pvi_compactness <- matrix(
						c(mean(dems_flipped), mean(dems_even), mean(dems_low), 
												mean(dems_med), mean(dems_high),
						  mean(gop_flipped), mean(gop_even), mean(gop_low),
						  						 mean(gop_med), mean(gop_high)),
						nrow=2, ncol=5, byrow=TRUE)
	dimnames(pvi_compactness) = list(c("Dems", "Reps"),
									 c("Flipped", "EVEN", "0<PVI<=5",
									 				"5<PVI<=15", "15<PVI"))

	pvi_length <- matrix(
						c(length(dems_flipped), length(dems_even),
						  length(dems_low), length(dems_med), length(dems_high),
						  length(gop_flipped), length(gop_even),
						  length(gop_low), length(gop_med), length(gop_high)),
						nrow=2, ncol=5, byrow=TRUE)
	dimnames(pvi_length) = list(c("Dems", "Reps"),
									 c("Flipped", "EVEN", "0<PVI<=5",
									 				"5<PVI<=15", "15<PVI"))
 
    return (list(pvi_compactness, pvi_length))
}


main <- function()
{
    df <- create_initial_dataframe()
    df <- add_additional_info(df)
    compactness_averages <- compactness_analysis(df)
    compactness_with_pvi <- compactness_with_pvi_analysis(df)
    print(compactness_averages)
    print(compactness_with_pvi)
}

if(!interactive()) {
    main()
}


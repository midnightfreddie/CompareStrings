This is inspired by my fledgling interest in machine learning and related
statistical analyses and [a reddit question](https://www.reddit.com/r/PowerShell/comments/5hf2vi/help_compare_string_to_string/).
The question included matching "CPU-INTEL6700K" and "Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz"
which is not doable with a simple operator.

I decided for the fun of it to make a function to compare these and match
them using the number of word character bigram matches.

In CompareString/CompareString.psm1 there is a function to convert a string
to a bigram vector and a function to return matching bigrams between two
bigram vectors. RunMe.ps1 runs this against the two strings from the reddit post. Sample output:

	The bigram matching score of CPU-INTEL6700K compared to Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz is 10

	Matches      Vector1Match      Vector2Match
	-------      ------------      ------------
		 10 0.909090909090909 0.526315789473684
   
   Originally I just had the number of bigram matches, then I decided it might be useful to also return the
   ratio of successful to possible matches for each vector, hence the two vector match properties.

   I don't have the questioner's info.txt file, but I wanted to simulate it and see how it worked against
   my pc. I pulled a lot of Intel i7 and i3 CPU models from Wikipedia and munged them into my info.txt in
   the format that the questioner was using. (He has an i7; I'm running on an i3.) CpuCompare.ps1 reads in
   my info.txt and creates an object array with the info line string and the bigram vector, and then it
   pulls my CPU name from WMI/CIM, compares that bigram-vectored value against the info array and then finds
   the top 10 matches. Originally I sorted by the number of matches but immediately noticed that the match
   ratio for the info line was a better metric for this case.

   Following is the result table. "CPU-INTEL350M" should be correct, but "CPU-INTEL4350" scored equally as
   well. 

	Matches      Vector1Match      Vector2Match String1        String2                                        
	-------      ------------      ------------ -------        -------                                        
		  8               0.8 0.470588235294118 CPU-INTEL4350  Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  8               0.8 0.470588235294118 CPU-INTEL350M  Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  7 0.777777777777778 0.411764705882353 CPU-INTEL950   Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  7 0.777777777777778 0.411764705882353 CPU-INTEL550   Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  8 0.727272727272727 0.470588235294118 CPU-INTEL4350T Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  8 0.727272727272727 0.470588235294118 CPU-INTEL2350M Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  7               0.7 0.411764705882353 CPU-INTEL4150  Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  7               0.7 0.411764705882353 CPU-INTEL3250  Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  6 0.666666666666667 0.352941176470588 CPU-INTEL530   Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz
		  6 0.666666666666667 0.352941176470588 CPU-INTEL540   Intel(R) Core(TM) i3 CPU       M 350  @ 2.27GHz

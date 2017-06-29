This is inspired by my fledgling interest in machine learning and related
statistical analyses and [a reddit question](https://www.reddit.com/r/PowerShell/comments/5hf2vi/help_compare_string_to_string/).
The question included matching "CPU-INTEL6700K" and "Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz"
which is not doable with a simple operator.

I decided for the fun of it to make a function to compare these and match
them using the number of word character bigram matches.

In CompareStrings/CompareStrings.psm1 there is a function to convert a string
to a bigram vector and a function to return matching bigrams between two
bigram vectors.

## RunMe.ps1

Runs `Get-Bigrams` against the two strings from the reddit post. Sample output:

	The bigram matching score of CPU-INTEL6700K compared to Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz is 10

	Matches      Vector1Match      Vector2Match
	-------      ------------      ------------
		 10 0.909090909090909 0.526315789473684
   
Originally I just had the number of bigram matches, then I decided it might be useful to also return the
ratio of successful to possible matches for each vector, hence the two vector match properties.

## CpuCompare.ps1

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

## AdSearch.ps1

A few months after creating this I saw [another reddit question](https://www.reddit.com/r/PowerShell/comments/6k2c4a/anyone_want_to_look_at_this_and_tell_me_ways_i/)
I thought could be relevant to this module. This file simulates fuzzy searching for AD users against a previously
exported and bigrammed list of users. The next step would be to pick the desired user and fetch the information
using the `Get-Aduser -Identity <SamAccountName>` or similar command. A function in the script shows how to export
the users and create the xml bigrams file.

I generated 30 names and IDs and then imagined a few misspelled searches for these users:

    Luvina


      Match SamAccountName Givenname Surname 
      ----- -------------- --------- ------- 
    0.11765 eie8963        Luvenia   Demasi  
    0.10526 qlr7586        Patrina   Mclellan
    0.07143 yuv3145        Bibi      Branum  
    0.06667 ows7809        Delta     Pizana  
    0.05882 wyd8719        Lajuana   Battey  

    Ashley

     0.1875 lim6003        Ashlie    Cozart  
      0.125 mhi2184        Ashely    Camire  
    0.11111 dlq9482        Gustavo   Cearley 
    0.07692 mtp1904        Valery    Kan     
    0.07692 uzi7855        Garry     Kyle    

    Enrica

    0.17647 uty5533        Arica     Brossard
    0.16667 rgs4192        Enriqueta Peden   
    0.11111 hwt8217        Patrice   Milhorn 
    0.07143 ucq6225        Aletha    Denn    
     0.0625 mhi2184        Ashely    Camire  

    Donavan

    0.23529 upi4851        Donovan   Rondon  
    0.15385 mtp1904        Valery    Kan     
    0.13333 ows7809        Delta     Pizana  
    0.11765 wyd8719        Lajuana   Battey  
    0.11765 ihx3335        Fernanda  Speed   

    Catherine

       0.25 kur8740        Katharine Londono 
    0.15789 qlr7586        Patrina   Mclellan
      0.125 mhi2184        Ashely    Camire  
    0.11765 uty5533        Arica     Brossard
    0.11111 hwt8217        Patrice   Milhorn 

    Faraby

    0.23529 nsi2028        Briana    Farabee 
    0.07692 tnz8172        Gigi      Fagan   
    0.07692 uzi7855        Garry     Kyle    
    0.07143 yuv3145        Bibi      Branum  
     0.0625 ipt9462        Clarisa   Zajac   

    mtp2004

    0.23077 mtp1904        Valery    Kan     
     0.0625 lim6003        Ashlie    Cozart  
    0.05882 nsi2028        Briana    Farabee 
    0.05556 dxf7604        Clarence  Konkol  
          0 pwf3210        Audra     Millsaps
# Identification of protein subcellular localization via integrating evolutionary and physicochemical information into Chou's general PseAAC

# About
We propose a multi-kernel SVM to predict subcellular localization of both multi-location and single-location proteins. We built a custome kernel for the SVM classifier, test the method on two human datasets and use three indicators to evaluate the results. We also compare our method with the RLS on two datasets. 

Input: Features extracted from protein, we use the PsePSSM,AvBlock,DWT and so on;
Labels of all samples;
The Cost;
The parameters(gamma) of calculating kernels of each feature are needed;
Kernels of festures are needed for RLS;

# Software
To run this program, you need to express all features in a matris, and use id to indicate the start and end position of each feature.

# Environment
MATLAB

8-core CPU

24 GB memory

64-bit Windows Operating Systems

# Data
There are two datasets in the folder.

D1 is collected from Swiss-Port database (release 55.3) by Shen and Chou[1]. This dataset contains 3106 samples and is divided into 14 classes, where 2580 proteins belong to one subcellular location, 480 to two locations, 43 to three locations, and 3 to four locations.
D2 is collected from both Swiss-Prot database and LOCATE database by Wei[2]. This dataset is built on the basis of D1, and contains 4802 samples, where 3448 belong to one location, 1311 to two locations, 40 to three, and 3 to four

# Result
Three evaluation indicators are obtained.

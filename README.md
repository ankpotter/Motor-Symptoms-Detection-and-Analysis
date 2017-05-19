# Motor-Symptoms-Detection-and-Analysis

The project involved unsupervised learning of accelerometer data to try and determine whether a person is in rest or motion. We were able to get very good results, with more than 98% accuracy for in-clinic data. It is done for patients of Parkinson's and Huntington's disease. Since teh satte is unknown and data is time series an HMM model with Viterbi is used. 

Activity recognition is the HMM code that assigns mean values to different states of a motor function.
Activity predictor is used to predict the current activity for every data point. 

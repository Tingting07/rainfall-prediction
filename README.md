# rainfall-prediction
## Project Introduction
To address the issues of insufficient data processing and significant discrepancies between predicted and actual results in existing medium and long-term rainfall prediction methods, this study proposes a multifeature hybrid rainfall prediction model that optimizes VMD parameters using the CPO optimization algorithm with the minimum information entropy as the objective function. The model integrates MIC feature selection and a CNN-GRU neural network. The model was validated via multifeature meteorological data from two typical regions and was compared with 17 other models. The results show that the proposed model outperforms other models in terms of robustness and prediction accuracy.
## Instruction for Use
This repository contains two folders: one is for monthly data, and the other is for weekly data. The code in the two folders is basically the same, but the original data and result files are different.

The file contains all the code used for parameter optimization, model construction, training and prediction.The user needs to open the file using MATLAB R2023b. month.xlsx is the raw monthly data and week.xlsx is the raw weekly data which contains precipitation and other meteorological data.
There are two folders in each folder; the parameter optimization folder contains the algorithms used in the study to optimize the decomposition parameters of the VMD, and the Decomposition and forecasting folder contains the various decomposition methods to decompose the raw data so that forecasting can be done in the main. 

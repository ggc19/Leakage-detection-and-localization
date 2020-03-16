# research data and model instruction
Some or all data, models, or code that support the findings of this study are available from the corresponding author upon reasonable request. Here, we present the main model codes for reviewers.

The total dataset is composed of 3150 normal samples and 2330 abnormal samples. The training dataset and testing dataset are 80% and 20% of the entire dataset, respectively. Ten-fold cross-validation is selected for optimizing model parameters and verifying the training results in order to avoid overfitting.

The file named 'LPC.py' is the LCP-based leakage detection models using raw datasets.
The file named 'LPC_noise.py' is the LCP-based leakage detection models using -5dB datasets.
The file named 'LPC.py' is the LPC-based leakage detectio models using raw datasets.
The file named 'LPC_noise.py' is the LPC-based leakage detection models using -5dB datasets.
The file named 'Time or frequency features.py' is the time or frequency features-based leakage detection models using raw datasets.
The file named 'Time or frequency features_noise.py' is the time or frequency features-based leakage detection models using -5dB datasets.
The file named 'CIS-experiment1.m' is the CIS algorithm for leakage localiztion. 
The file named 'Ordinary-experiment1.m' is the ordinary search algorithm for leakage localiztion. 

The detection models are implemented by scikit-learn tool and some python packages. Run them in Anaconda3 (Spyder) platform. The signal processing methods and localization models are implemented by matlab R2014a.

Corresponding author: Shuming Liu, 
Professor, School of Environment, Tsinghua University
E-mail: shumingliu@tsinghua.edu.cn

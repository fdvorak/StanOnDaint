# A brief guide to fitting Bayesian models on Piz Daint (cscs.ch)
Author: Fabian Dvorak (ESS, Eawag)
Date: 2023-07-26

This vignette describes Bayesian model fitting using R and Stan on Piz Daint, one of the supercomputers run by the Swiss National Supercomputing Centre. It shows how to (1) use JupyterLab to access PizDaint, and (2) use R and Stan to replicate this example.

## Prerequisites 
* Get a CSCS account. Contact Eawag’s Scientific-IT & Research Data Management. They can request that a personal account is set up for you on Eawag’s share of the file system (project ID em09).
* Enable multi-factor authentication to access CSCS services. See the link for the details.
* Log in to JupyterLab interface here, using the credentials of your account. Select 1 CPU node, which should be enough, and an appropriate wall time limit for your estimation. If you need more computational resources, it should in principle be possible to use several nodes with MPI and cmdstanpy, but I haven’t had the time to explore this possibility.

## Setting up the R environment in JupyterLab
Before we can start fitting the models, we have to set up the R environment in JupyterLab. More information on interactive supercomputing with JupyterLab can be found here.
* Create a folder called “R_library” in your home directory (/users/your username). Then, start a terminal session by clicking on the plus symbol and execute “jupyterhub --generate-config” in the terminal window. This should create a python file called “jupyterhub_config” in your home folder. Open the file and add the following line “export R_LIBS_USER=R_library” (without the quotes).
* Now you should be able to install all necessary R packages with the usual command (install.packages). I recommend using the R package cmdstanr (instead of rstan) as Stan interface because it features within-chain parallelization. Within-chain parallelization is necessary to exploit the full potential of the supercomputer as one CPU node of Piz Daint gives you access to 72 cores. This means that when estimating 4 parallel chains, you can use up to 68 cores per chain for within-chain parallelization that are idle otherwise. In order to use within-chain parallelization, you have to use the reduce_sum function in the definition of your model.

## File Transfers
Use the CSCS globus online endpoint to transfer files. 
* To run the example models, download the files of this repository to your local machine. 
* Transfer the downloaded files (stan_example_PizDaint.ipynb, Redcard.csv, logistic0.stan and logistic1.stan) from your local machine to your scratch folder (/scratch/snx3000/your username). Note that all files in scratch will be automatically deleted after 30 days! Use the project folder for permanent storage of valuable files. See here for a documentation of Daint’s file system.

## Model fitting
You should now be able to fit models.
* Execute the jupyter notebook “stan_example_PizDaint.ipynb”. This notebook fits two models one without, and one with within-chain parallelization. The estimation time of both models is displayed at the end to illustrate the performance gain of within-chain parallelization. The posterior samples of both models are stored as csv files in the scratch folder and can be post-processed with the designated functions of the cmdstanr package. If post-processing should be done based on rstan instead, the csv files can be combined to a stanfit object with the command “stanfit1 <- rstan::read_stan_csv(fit1$output_files())”.
* Finally, a good practice is to use chkptstanr to set checkpoints during the estimation.

If you have comments, corrections or other feedback, feel free to contact me (fabian.dvorak[at]eawag.ch).

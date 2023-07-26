# A brief guide to fitting Stan models on Piz Daint
Author: Fabian Dvorak (ESS, Eawag)

Date: 2023-07-26

This vignette describes Bayesian model fitting using [R]( https://www.r-project.org/) and [Stan](https://mc-stan.org/) on the Piz Daint supercomputer of the [Swiss National Supercomputing Centre (CSCS)](https://www.cscs.ch/). It illustrates how to (1) use JupyterLab to access PizDaint, and (2) use R and Stan to replicate [this example](https://mc-stan.org/users/documentation/case-studies/reduce_sum_tutorial.html).

## Prerequisites 
* Get a CSCS account. Contact Eawag's Scientific-IT & Research Data Management. They can request that a personal account is set up for you on Eawag's share of the file system (project ID em09).

* Enable multi-factor authentication to access CSCS services as described [here](https://user.cscs.ch/access/auth/mfa/).

* Log into [JupyterLab](https://jupyter.cscs.ch/), using the credentials of your account. Select the number of CPU nodes and an appropriate wall time limit. A single node should be sufficient for most cases. If you need more computational resources, it should be possible to use several nodes with MPI, but you have to use python (cmdstanpy) (I haven't had the time to validate this possibility).

## Setting up the R environment in JupyterLab
Before we can start fitting the models, we have to set up the R environment in JupyterLab. More information on interactive supercomputing with JupyterLab can be found [here](https://user.cscs.ch/tools/interactive/jupyterlab/).

* Create a folder called "R_library" in your home directory (/users/your username). Then, start a terminal session by clicking on the plus symbol and execute "jupyterhub --generate-config" in the terminal window. This should create a python file called "jupyterhub_config" in your home folder. Open the file and add the following line "export R_LIBS_USER=R_library" (without the quotes).

* Now you should be able to install all necessary R packages with the usual command (install.packages). I recommend using the R package [cmdstanr](https://mc-stan.org/cmdstanr/index.html) (instead of rstan) as Stan interface because it features within-chain parallelization. Within-chain parallelization is necessary to exploit the full potential of the supercomputer as one CPU node of Piz Daint gives you access to 72 cores. This means that, when estimating 4 parallel chains, you can use up to 68 cores for within-chain parallelization that would remain idle otherwise. Not that, in order to use within-chain parallelization, you have to use the [reduce_sum](https://mc-stan.org/docs/functions-reference/functions-reduce.html) function in the definition of your model.

## File Transfers
Use the [CSCS globus online endpoint](https://user.cscs.ch/storage/transfer/external/) to transfer files. 

* To run the example models, download the files Redcard.csv, logistic0.stan, and logistic1.stan from [this repository](https://github.com/rmcelreath/cmdstan_map_rect_tutorial) to your local machine. 

* Transfer the downloaded files from your local machine to your [scratch](https://user.cscs.ch/storage/file_systems/scratch/) folder (/scratch/snx3000/your username). Note that all files in scratch will be automatically deleted after 30 days! Use the project folder for permanent storage of valuable files. [Here](https://user.cscs.ch/storage/file_systems/scratch/) is the documentation of Daint's file system.

## Model fitting
You should now be able to fit models.

* Launch a new JupyterLab notebook using an R kernel by clicking on the plus symbol and selecting the R icon.

* Copy the R code in StanOnDaint.R of this repository into the first cell of the notebook. 

* Execute the notebook. This notebook fits two models. One without, and one with within-chain parallelization. The estimation time of both models is displayed at the end to illustrate the performance gain. 

* The posterior samples of both models are stored as csv files in the scratch folder and can be post-processed with the designated functions of the cmdstanr package. When post-processing should be done based on rstan instead, the csv files can be combined to a stanfit object with the command "stanfit1 <- rstan::read_stan_csv(fit1$output_files())".

* A good practice is to use [chkptstanr](https://donaldrwilliams.github.io/chkptstanr/) to set checkpoints during the estimation.

Finally, put the following sentence in the acknowledgment section of your paper: "We acknowledge access to Piz Daint at the Swiss National Supercomputing Centre, Switzerland under Eawag’s share with the project ID em09." 

If you have comments, corrections or other feedback, feel free to contact me (fabian.dvorak[at]eawag.ch).

# Replication Package
>#### Visions of Deliverance: Social Scientization, Functionalism, and the Expansive Purposiveness of Education in Nineteenth-century British Parliamentary Politics.

__This replication package is still under development pending peer review.__ The main results reported in the [paper](http://danielscottsmith.com/vita/r4) can nonetheless be replicated. A few cautionary notes before proceeding: 
1. The data, raw and processed, must be first downloaded from dataverse. This package doesn't yet replicate the data processing, so you need to download both processed and raw data at the link below.
1. The code currently sprawls across Jupyter, R, and Stata and its organization does not yet transparently express the data-analytic procedures and sequence to reproduce all processed data and results.
1. Currently, this package only replicates analyses on the processed data (not the processing of the raw data).

---
## Getting Started

1. Clone this depository.  
1. Download [`data` folder](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/KKBCIX) from Dataverse. 
1. Place the downloaded `data` folder in directory root: `00_replication/00_data/`
1. Launch Stata and change directory to root: `00_replication/`
1. Change the global variable `DIR` at the top of `00_an_new.do` to root: `00_replication/`
1. Execute all code.

---
## To Do

1. programmatize notebooks
1. add STM to reported appendix
1. programmatize R code
1. standardize filenames
1. programmatize do files and create main.do
1. clean out and repopulate subdirectories

---
## Project Organization

Below is a map of the directory with annotations for general orientation.

---

    ├── README.md          <- The top-level README for developers using this project.
    ├── 00_data
    │   ├── 00_dvs         <- outcomes of interest
    │   ├── 01_ivs         <- question predictors
    │   ├── 02_bluebooks   <- raw data 
    │   ├── 03_acts        <- raw data 
    │   ├── 04_journals    <- raw data 
    │   ├── 98_stm200      <- STM thetas and terms for robustness checks
    │   └── 99_lda200      <- LDA thetas and terms, used to compute dvs  
    │
    ├── 01_scripts         <- Stata, R, and Jupyter notebook files. 
    │
    └── 02_visuals         
        ├── 00_text        <- visualized results in report
        └── 01_appendix    <- visualized results in appendix

--------

# MEND-dataset
[![Paper PDF](https://img.shields.io/badge/Paper-PDF-red.svg)]() [![huggingface](https://img.shields.io/badge/%F0%9F%A4%97-Data-yellow)]() [![Python 3.8+](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3109/)

<!-- <div style="width: 100%;">
  <img src="./fig/" style="width: 100%;" alt="memory_framwork"></img>
</div> -->

## 📌 Table of Contents
- [Data Structure](#data-structure)
- [Data Process](#data-process)
  - [Install](#install)
  - [Get Full Profile](#get-full-profile)
  - [Process CLHLS Dataset](#process-clhls-dataset)


## Data Structure
```
ECAS-DATASET
├─dec                           # All generated data
│  ├─profiles
│  ├─memory 
│  │  ├─ori_data               
│  │  └─database.db             # Stored in database
│  └─dialogues
```


## Data Process

### Install

1. Starting a virtual environment with anaconda:

```bash
conda create -n mod_dec python=3.11.0
```

2. Then install requirements for initing client and chatting with client agent.

```bash
pip install -r requirements.txt
```


### Process CLHLS Dataset

1. Due to the privacy of real patient data, you need get REAL data from [CLHLS dataset website](https://opendata.pku.edu.cn/dataset.xhtml?persistentId=doi:10.18170/DVN/WBO7LK), we use the data of "CLHLS_dataset_2008-2018_SPSS", and put it in the `./utils/CLHLS` folder..

2. Clean the CLHLS data using [Stata](https://download.stata.com/download/) software (we used StataMP 17), and Our data cleaning code is available in the `./utils` folder.

3. Place the generated `.dta` file in the `./utils/CLHLS` folder and run the following command to further process the data:

```
python clhls_process.py
```

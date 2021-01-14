# paper-pao-review

Data and code repository for the paper titled *A Critical Review of Polyphosphate and Polyphosphate Accumulating Organisms for Agricultural Water Quality Management*.

<Zenodo DOI tag>

This README.md file was generated on 2020-12-10 by Sheila Saia.

## General Information

**Title of Dataset**<br>

"paper-pao-review"

**Brief Dataset Description**

This GitHub repository was created to provide access to collected data, analysis code, and other information associated with the paper by Saia et al. titled, *A Critical Review of Polyphosphate and Polyphosphate Accumulating Organisms for Agricultural Water Quality Management* in Environmental Science & Technology (XXXX, preprint: https://eartharxiv.org/repository/view/1132/).

**Dataset Contact Information**<br>
Name: Sheila Saia<br>
Institution: North Carolina State University, Department of Biological & Environmental Engineering<br>
Address: 3100 Faucette Drive, Raleigh, NC 27695, USA<br>
Email: ssaia at ncsu dot edu<br>
Role: author, maintainer<br>

**Date of Data Collection**<br>

We retrieved all data for this study on 2020-03-10 from the [Web of Science](https://www.webofknowledge.com) servers using the [`rwos` R package](https://github.com/juba/rwos).<br>

Note: the `rwos` R package is no longer being maintained (as of October 2018).

**Geographic location of data collection**<br>

There is no geographic boundary for data included here.

**Information about funding sources that supported the collection of the data**<br>

Sheila Saia was supported by a [US EPA](https://www.epa.gov/) STAR Fellowship and a [USDA NIFA](https://nifa.usda.gov/) grant (#2014-67019-21636).

## Sharing & Access Information ##

**Licenses/restrictions placed on the data**<br>

Please cite this work (see recommended citation below and in the [CITATION.md file](https://github.com/sheilasaia/paper-pao-review/blob/master/CITATION.md) in this repository) and use/distribute according to the CC-BY v4.0 license.

For a full view of the license visit the [LICENSE.md](https://github.com/sheilasaia/paper-pao-review/blob/master/LICENSE.md) file in this repository. For a human readable version of this license visit https://creativecommons.org/licenses/by/4.0/.

**Links to publications that cite or use the data**<br>

As of 2020-12-10 there are no other publications that cite or use these data.

**Links to other publicly accessible locations of the data**<br>

This dataset and associated R code are available at https://github.com/sheilasaia/paper-pao-review and via Zenodo (XXXX). The associated publication is available via Environmental Science & Technology (https://doi.org/10.1086/691439) and the Earth ArXiv (preprint: https://eartharxiv.org/repository/view/1132/).

**Links/relationships to ancillary data**<br>

There are no ancillary data associated with this paper.

**Data derived from another source**<br>

We downloaded all data associated with this paper on 2020-03-10 from the [Web of Science](https://www.webofknowledge.com) servers using the [`rwos` R package](https://github.com/juba/rwos). Please see the paper and code for a full description of methods.

**Additional related data collected that was not included in the current data package**<br>

There are no other related data collected besides what is included here.

**Are there multiple versions of the dataset?**<br>

There are no other versions of the data associated with this paper.

**Recommended citation for the data**<br>

See [CITATION.md](https://github.com/sheilasaia/paper-pao-review/blob/master/CITATION.md) for the recommended citation for these data and code.

**Paper Availability**<br>

The associated publication is available via Environmental Science & Technology (https://doi.org/10.1086/691439) and the Earth ArXiv (preprint: https://eartharxiv.org/repository/view/1132/).

## Methodological Information ##

**Description of methods used for collection/generation of data:**<br>

Briefly, we used the R `rwos` package and other R packages to pull data from the Web of Science servers and generate figures included in the manuscript. We provide a detailed description of the methods used to collect and analyze these data in the associated code and publication. The publication is available via Environmental Science & Technology (https://doi.org/10.1086/691439) and the Earth ArXiv (preprint: https://eartharxiv.org/repository/view/1132/).

**Methods for processing the data:**<br>

We included the raw data from each Web of Science query in this repository in the [raw\_data directory](https://github.com/sheilasaia/paper-pao-review/tree/master/data/raw_data) and all post-processed data are included in the [processed\_data directory](https://github.com/sheilasaia/paper-pao-review/tree/master/data/processed_data).

Besides the raw data that was obtained directly from Web of Science, we created the `wos_topical_paper_counts_raw.csv` raw data file by manually adding paper counts to the csv file for each corresponding Web of Science query. This file is the only data file that was created manually.

**Instrument- or software-specific information needed to interpret the data:**<br>

All data collection, processing, and analysis was done in R (v3.6.2) using RStudio desktop (v1.3.1093) on an iMac desktop (macOS Mojave v10.14.6, 2.3 GHz Intel Core i5, 16 GB 2133 MHz DD4, Intel Iris Plus Graphics 640 1536 MB).

We also used the following R packages: `rwos` (v0.0.1), `tidyverse` (v1.3.0), `here` (v0.1), `beepr` (v1.3), `ggforce` (v0.3.1), `gridExtra` (v2.3), and `ggupset` (v0.3.0), and `renv` (v0.12.5).

*NOTE:* Users of these scripts can use the `renv` R package to activate the R packages used in this R project repository. Run the code below to activate the R environment that we used for all analysis in your RStudio session.

```
# Make sure you are running code as an *RStudio project*. To do this, download the whole GitHub repository and double click on the paper-pao-review.Rproj file. This will open RStudio and anchor your RStudio session to this project. Once you have done this, follow the steps below.

# 1. install the renv R package
install.packages("renv")

# 2. load the library
libary(renv)

# 3. initialize the environment in your RStudio session
renv::activate()

# 4. Run the scripts as you normally would.
```

**Standards and calibration information, if appropriate:**<br>

There are no applicable standards and calibration information.

**Environmental/experimental conditions:**<br>

There are no applicable environmental/experimental conditions.

**Describe any quality-assurance procedures performed on the data:**<br>

We post-process raw Web of Science data using R. See the `wos_data_analysis_script.R` (part 3) for more information.

**People involved with sample collection, processing, analysis and/or submission:**<br>

Sheila Saia collected, processed, analyzed, and submitted the data using the code associated with this repository. If you find any errors, please submit [an issue](https://github.com/sheilasaia/paper-pao-review/issues) or contact Sheila Saia at ssaia at ncsu dot edu.

## Data & File Overview

### 1. main directory ###

**File List**

The main directory contains the following documentation files:

* `CITATION.md` - This file contains information on how to cite the data, code, and paper associated with this repository.
* `CONTRIBUTING.md` - This file contains information on how to notify the maintainer of issues with the code.
* `LICENSE.md` - This file contains information regarding how this work is licensed and how to give attribution.
* `README.md` - This file (here) provides overall information on about the content and organization of this repository.

The main directory contains the following R-related files:

* `paper-pao-review.Rproj` - This is the RStudio project file.
* `wos_data_retrieval_script.R` - The purpose of this R script is to retrieve data from Web of Science.
* `wos_data_analysis_script.R` - The purpose of this R script is to process, analysis, and plot results of data retrieved from the Web of Science.

The main directory contains the following sub-directories, which are explained in further detail below.

* `data` - This directory contains the raw and processed data associated with the manuscript.
* `figures` - This is the output directory for figures generated the `wos_data_analysis_script.R script`.

**Relationship Between Files**<br>

Outputs from `wos_data_retrieval_script.R` are needed to run `wos_data_analysis_script.R`. Tabular outputs both of the R scripts (`.R` files) are found in the data sub-directories. See more details in sections 2 and 3 below. Figure outputs from `wos_data_analysis_script.R` are found will be exported to the figure directory.

### 2. data directory ###

#### 2.1 raw_data directory ####

**File List & Relationship Between Files**

The raw_data directory contains raw Web of Science query results for the various searches included in the associated paper.

The file naming convention is as follows. The majority of file names start with either `microbio*`, `pao*`, `polyp*`, and `phos*`, which refer to the four overall keyword search topics: "microbiology", "polyphosphate accumulating organisms", "polyphosphate", and "phosphate", respectively. The second part of the file name refers to additionally environmental-specific keywords that were added to the Web of Science topic search, including: `*_ag_*`, `*_fw_*`, `*_lake_*`, `*_marine_*`, `*_ocean_*`, `*_river_*`, `*_sed_*`, `*_soil_*`, `*_stream_*`, `*_sw_*`, `*_wwt_*`, which refer to the 11 environments included in queries used in this study: "agriculture", "freshwater", "lake", "marine", "ocean", "river", "stream", "sediment", "soil", "stream", "saltwater", and "wastewater treatment". For more details on these searches see the manuscript methods and Table S2 in the manuscript.

There are three exception to this file naming structure. These are described below.

First, there are three files that do not have an environmental-specific keyword. These are `microbio_pubs_raw.csv`, `polyp_pubs_raw.csv`, and `pao_pubs_raw.csv` and these files include all query results based on topic alone. Put another way, these queries may represent environments that are included in this study as well as those that are not. See the methods section i the paper (Section 2) and "all" category in Table S2 in the manuscript for further explanation. Note: there is no `phos_pubs_raw.csv` file because there were more than 10,000 query results for this search. In this case, query results could not be downloaded from Web of Science; we could only record the number of query results, which is reported in Table S2. For further explanation of this limitation, see the methods section of the paper (Section 2).

Second, there are four files that end in `*all_searches_pubs_raw.csv`. These refer to a merged version the Web of Science queries by topic and environment described as well as query results by topic for environments not included in this study (i.e., "all" category as described in the previous paragraph). Note: the `phos_all_searches_pubs_raw.csv` does not include "all" searches because of limitations described in the previous paragraph. The other three files; however, do include the "all" category results.

Third, there are two files that start with `wos*`. These refer to Web of Science queries by year (i.e., `wos_annual_paper_counts_raw.csv`) used to generate Figure SX and summaries of keyword searches by topic (i.e., `wos_topical_paper_counts_raw.csv`) used to generate Tabls S2. Note: the  `wos_annual_paper_counts_raw.csv` was generated as an output from the `wos_data_retrieval_script.R` script but `wos_topical_paper_counts_raw.csv` was generated manually as described above in the main directory file list.

## Data-Specific Information For: `*topic*_*environment*_pubs_raw.csv` and similar files ##

For example, `microbio_ag_pubs_raw.csv`.

**Number of columns/variables**

Number of columns: 17

**Number of rows**

Number of rows: varies

**Variable list**<br>

* uid - Web of Science unique publication identifier (accession number)
* title - publication title
* journal - publication journal
* issue - publication issue number
* volume - publication volume number
* pages - publication page numbers
* date -  publication date (month, or month-day)
* year - publication year
* authors - publication authors
* keywords - publication keywords
* doi - publication digital object identifier (DOI)
* article_no - publication article number
* isi_id - publication Institute for Scientific Information (ISI) identifier
* issn - publication ISSN
* isbn - publication ISBN
* environment - detailed environment category (this study)
* category - general environment category (this study)

**Missing data codes**<br>

Missing data is either labeled with "NA" for all columns except the authors and keywords columns, which are both left blank in the case of missing information.

**Specialized formats or other abbreviations used:**

All specialized formats and abbreviations are described here.

## Data-Specific Information For: `*topic*_all_searches_pubs_raw.csv` and similar files ##

For example, `microbio_ag_pubs_raw.csv`.

**Number of columns/variables**

Number of columns: 17

**Number of rows**

Number of rows: varies

**Variable list**<br>

* uid - Web of Science unique publication identifier (accession number)
* title - publication title
* journal - publication journal
* issue - publication issue number
* volume - publication volume number
* pages - publication page numbers
* date -  publication date (month, or month-day)
* year - publication year
* authors - publication authors
* keywords - publication keywords
* doi - publication digital object identifier (DOI)
* article_no - publication article number
* isi_id - publication Institute for Scientific Information (ISI) identifier
* issn - publication ISSN
* isbn - publication ISBN
* environment - detailed environment category (this study)
* category - general environment category (this study)

**Missing data codes**<br>

Missing data is either labeled with "NA" for all columns except the authors and keywords columns, which are both left blank in the case of missing information.

**Specialized formats or other abbreviations used:**

All specialized formats and abbreviations are described here.

## Data-Specific Information For: `wos_annual_paper_counts_raw.csv` file ##

**Number of columns/variables**

FIXME

**Number of rows**

FIXME

**Variable list**<br>

FIXME (fill in variables and their meaning)

**Missing data codes**<br>

FIXME

**Specialized formats or other abbreviations used:**

FIXME

## Data-Specific Information For: `wos_topical_paper_counts_raw.csv` file ##

**Number of columns/variables**

Number of columns: 4

**Number of rows**

Number of rows: 49

**Variable list**<br>

* keyword - topic keyword abbreviation (this study)
* environment - detailed environmental keyword abbreviation (this study)
* category - general environment keyword abbreviation (this study)
* count - paper count (this study)

**Missing data codes**<br>

There is no missing data.

**Specialized formats or other abbreviations used:**

The following abbreviations are used in this file:

* phosphorus (phos)
* microbiology (microbio)
* polyphosphate (polyp)
* polyphosphate accumulating organism (pao)
* wastewater treatment (wwt)
* "all" refers to all environments included and NOT included in this study

There are no specialized formats used in this file.

#### 2.2 processed_data directory ####

**File List**

FIXME (list all files or folders, as appropriate for dataset organization contained in the dataset, with a brief description)

**Relationship Between Files**<br>

FIXME

## Data-Specific Information For: FIXME (file name) ##

**Number of columns/variables**

FIXME

**Number of rows**

FIXME

**Variable list**<br>

FIXME (fill in variables and their meaning)

**Missing data codes**<br>

FIXME

**Specialized formats or other abbreviations used:**

FIXME

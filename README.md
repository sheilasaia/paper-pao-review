# paper-pao-review

Data and code repository for the paper titled *Critical Review of Polyphosphate and Polyphosphate Accumulating Organisms for Agricultural Water Quality Management*.

This README.md file was generated on 2020-12-10 by Sheila Saia.

## General Information

**Title of Dataset**<br>

"paper-pao-review"

**Brief Dataset Description**

This GitHub repository was created to provide access to collected data, analysis code, and other information associated with the paper by Saia et al. titled, *Critical Review of Polyphosphate and Polyphosphate Accumulating Organisms for Agricultural Water Quality Management* in Environmental Science & Technology (XXXX, preprint: https://eartharxiv.org/repository/view/1132/).

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

This dataset and associated R code are available at https://github.com/sheilasaia/paper-pao-review. The associated publication is available via Environmental Science & Technology (https://doi.org/10.1086/691439) and the Earth ArXiv (preprint: https://eartharxiv.org/repository/view/1132/).

**Links/relationships to ancillary data**<br>

There are no ancillary data associated with this paper.

**Data derived from another source**<br>

We downloaded all data associated with this paper on 2020-03-10 from the [Web of Science](https://www.webofknowledge.com) servers using the [`rwos` R package](https://github.com/juba/rwos). Please see the manuscript methods (Section 2) and code for a full description.

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

*NOTE:* Users of these scripts can use the [`renv` R package](https://rstudio.github.io/renv/articles/renv.html) to activate the R packages used in this R project repository. Run the code below to activate the R environment that we used for all analysis in your RStudio session.

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
* `figures` - This is the output directory for figures generated by the `wos_data_analysis_script.R script`.

**Relationship Between Files**<br>

Outputs from `wos_data_retrieval_script.R` are needed to run `wos_data_analysis_script.R`. Tabular outputs from both of the R scripts (`.R` files) are found in the data sub-directories. See more details in sections 2 and 3 below. Figure outputs from `wos_data_analysis_script.R` are found will be exported to the figure directory.

### 2. data directory ###

#### 2.1 raw_data directory ####

> A "\*" (asterisk) in the file name of this README document indicates a [wild card](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm). That is, a number of characters may take the place of the "\*".

**File List & Relationship Between Files**

The raw_data directory contains raw Web of Science query results for the various searches included in the associated paper.

The file naming convention is as follows. The majority of file names start with either `microbio*`, `pao*`, `polyp*`, and `phos*`, which refer to the four overall keyword search **topic**-specific keywords: "microbiology", "polyphosphate accumulating organisms", "polyphosphate", and "phosphate", respectively. The second part of the file name refers to additionally environmental-specific keywords that were added to the Web of Science topic search, including: `*_ag_*`, `*_fw_*`, `*_lake_*`, `*_marine_*`, `*_ocean_*`, `*_river_*`, `*_sed_*`, `*_soil_*`, `*_stream_*`, `*_sw_*`, `*_wwt_*`, which refer to the 11 environments included in queries used in this study: "agriculture", "freshwater", "lake", "marine", "ocean", "river", "stream", "sediment", "soil", "stream", "saltwater", and "wastewater treatment". For more details on these searches see the manuscript methods (Section 2) and Table S2 in the manuscript.

There are three exceptions to this file naming structure. These are described below.

First, there are three files that do not have **environment**-specific keywords. These are `microbio_pubs_raw.csv`, `polyp_pubs_raw.csv`, and `pao_pubs_raw.csv` and these files include all query results based on topic alone. Put another way, these queries may represent environments that are included in this study as well as those that are not. See the manuscript methods (Section 2) and "all" category in Table S2 in the manuscript for further explanation. Note: there is no `phos_pubs_raw.csv` file because there were more than 10,000 query results for this search. In this case, query results could not be downloaded from Web of Science; we could only record the number of query results, which is reported in Table S2. For further explanation of this limitation, see the manuscript methods (Section 2).

Second, there are four files that end in `*all_searches_pubs_raw.csv`. These refer to a merged version the Web of Science queries by topic and environment described as well as query results by topic for environments not included in this study (i.e., "all" category as described in the previous paragraph). Note: the `phos_all_searches_pubs_raw.csv` does not include "all" searches because of limitations described in the previous paragraph. The other three files; however, do include the "all" category results.

Third, there are two files that start with `wos*`. These refer to Web of Science queries by year (i.e., `wos_annual_paper_counts_raw.csv`) used to generate Figure S1 and summaries of keyword searches by topic (i.e., `wos_topical_paper_counts_raw.csv`) used to generate Table S2. Note: the  `wos_annual_paper_counts_raw.csv` was generated as an output from the `wos_data_retrieval_script.R` script but `wos_topical_paper_counts_raw.csv` was generated manually as described above in the main directory file list.

## Data-Specific Information For: `*(topic)_*(environment)*_pubs_raw.csv` and similar files ##

> Here, \*(topic)\* refers to one of the four topics discussed above and \*(environment)\* refers to one of the 11 environments discussed above.

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

## Data-Specific Information For: `*(topic)*_all_searches_pubs_raw.csv` and similar files ##

> Here, \*(topic)\* refers to one of the four topics discussed above.

For example, `microbio_all_searches_raw.csv`.

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

Number of columns: 2

**Number of rows**

Number of rows: 31

**Variable list**<br>

* year - year
* wos_wide_count - number of publications published in Web of Science (wos)

**Missing data codes**<br>

There are no missing values.

**Specialized formats or other abbreviations used:**

There are no specialized formats or abbreviations used in this file.

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
* As previously described in the exceptions to file naming conventions, "all" indicates a result from a search that was based on topic only and not considering a specific environment. These records could therefore include environments that were the focus of our study as well as others that were not.

There are no specialized formats used in this file.

#### 2.2 processed_data directory ####

> A "\*" (asterisk) in the file name of this README document indicates a [wild card](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm). That is, a number of characters may take the place of the "\*".

**File List & Relationship Between Files**

The processed_data directory contains post-processed Web of Science results for the various searches included in the associated paper.

The file naming convention is as follows. The majority of file names start with either `microbio*`, `pao*`, `polyp*`, and `phos*`, which refer to the four overall keyword search topics: "microbiology", "polyphosphate accumulating organisms", "polyphosphate", and "phosphate", respectively. The second part of the file name refers to additionally environmental category-specific keywords that were added to the Web of Science topic search, including: `*_ag_*`, `*_fresh_*`, `*_mar_*`, `*_terr_*`, and `*_wwt_*`, which refer to the 5 environmental categories included in queries used in this study: "agriculture", "freshwater", "marine", "terrestrial", and, and "wastewater treatment", respectively. For more details on these searches see the manuscript methods (Section 2) and Table S2 in the manuscript.

Additional file naming conventions are as follows. Files with `*_all_searches_pubs.csv` included in the name, refer to merged Web of Science query results generated for the four main keyword searches using `wos_data_retrieval_script.R`. NOTE: The  `phos_all_searches_pubs.csv`does not include results in the "all" category because there were more than 100K results and these could not be downloaded. See note in `wos_data_retrieval_script.R` and the methods section of the manuscript (Section 2) for further details. Files with `*_set_data.csv*` included in the name, refer to Web of Science query results sets generated for the four main keyword searches using `wos_data_analysis_script.R` (see code section 7.1). These results were used to make Figure 3.

The remaining files listed below refer to filtered versions of the `*_all_searches_pubs.csv` and `*_set_data.csv` data that were required for the discussion of meta-analysis results in the manuscript. These files all have the same column and row format as the `*_all_searches_pubs.csv`. Filtering was done in the `wos_data_analysis_script.R` and files were exported (see code section 7.2) to the processed_data directory. These remaining are as follows:

* `polyp_all_ag_pubs.csv` - Filtered `polyp_all_searches_pubs.csv` to include all publications in the "agricultural" category.
* `pao_all_ag_pubs.csv` - Filtered `pao_all_searches_pubs.csv` to include all publications in the "agricultural" category.
* `polyp_wwt_only_pubs.csv` - Filtered `polyp_set_data.csv` to publications that only include "wastewater treatment" category publications (i.e., they had no overlap with other categories).
* `pao_wwt_only_pubs.csv` - Filtered `pao_set_data.csv` to publications that only include "wastewater treatment" category publications (i.e., they had no overlap with other categories).
* `polyp_pao_mar_fresh_terr_pubs.csv` - Joined `polyp_all_searches_pubs.csv`and `polyp_all_searches_pubs.csv` to find publications in both keywords that included "marine" AND "freshwater" AND "terrestrial" category publications.
* `polyp_terr_only_pubs.csv` - Filtered `polyp_set_data.csv` to publications that only include "terrestrial" category publications (i.e., they had no overlap with other categories).
* `pao_terr_only_pubs.csv` - Filtered `pao_set_data.csv` to publications that only include "terrestrial" category publications (i.e., they had no overlap with other categories).
* `polyp_terr_plus_pubs.csv` - Filtered `polyp_set_data.csv` to include all publications in the "terrestrial" category (i.e., they had overlap with terrestrial and at least one or more other category).
* `pao_terr_wwt_pubs.csv` -  Filtered `pao_set_data.csv` to publications that included "terrestrial" and "wastewater treatment" category publications (i.e., they had overlap with these two categories only).
* `terr_polyp_pao_pubs.csv` - Joined `polyp_all_searches_pubs.csv`and `polyp_all_searches_pubs.csv` to find publications in both keywords that included "terrestrial" category publications.
* `polyp_fresh_only_pubs.csv` - Filtered `polyp_set_data.csv` to publications that only include "freshwater" category publications (i.e., they had no overlap with other categories).
* `pao_fresh_wwt_pubs.csv` - Filtered `pao_set_data.csv` to publications that included "freshwater" and "wastewater treatment" category publications (i.e., they had overlap with these two categories only).
* `fresh_polyp_pao_pubs.csv` - Joined `polyp_all_searches_pubs.csv`and `polyp_all_searches_pubs.csv` to find publications in both keywords that included "freshwater" category publications.
* `polyp_mar_only_pubs.csv` - Filtered `polyp_set_data.csv` to publications that only include "marine" category publications (i.e., they had no overlap with other categories).
* `pao_mar_wwt_pubs.csv` - Filtered `pao_set_data.csv` to publications that included "marine" and "wastewater treatment" category publications (i.e., they had overlap with these two categories only).
* `polyp_pao_mar_pubs.csv` - Joined `polyp_all_searches_pubs.csv`and `polyp_all_searches_pubs.csv` to find publications in both keywords that included "marine" category publications.
* `phos_terr_only_pubs.csv` - Filtered `phos_set_data.csv` to publications that only include "terrestrial" category publications (i.e., they had no overlap with other categories).

The final file included here is the `table_s4_results.csv` file, which was generated in the `wos_data_analysis_script.R` (see code section 6.1) for Table S4.

## Data-Specific Information For: `*_all_searches_pubs.csv` ##

**Number of columns/variables**

* uid - Web of Science unique publication identifier (accession number)
* title - publication title
* journal_fix - publication journal with title case fixed
* journal_short - publication journal shorted to first three words
* year_fix - publication year with white space removed and as a number
* keywords_fix - publication keywords with spacing removed and separated by commas
* authors_fix - publication authors with spaces replaced with "_" and separated by commas
* environment - detailed environment category (this study)
* category - general environment category (this study)

**Number of rows**

Number of rows: Varies

**Variable list**<br>

Number of columns: 9

**Missing data codes**<br>

Missing data is labeled with "NA".

**Specialized formats or other abbreviations used:**

The following abbreviations are used in these files:

* phosphorus (phos)
* microbiology (microbio)
* polyphosphate (polyp)
* polyphosphate accumulating organism (pao)
* wastewater treatment (wwt)
* As previously described in the exceptions to file naming conventions, "all" indicates a result from a search that was based on topic only and not considering a specific environment. These records could therefore include environments that were the focus of our study as well as others that were not.

There are no specialized formats used in these files.

## Data-Specific Information For: `*_set_data.csv` ##

**Number of columns/variables**

* uid - Web of Science unique publication identifier (accession number)
* category_str - general environment category (this study) string listing all the categories that the publication fell into for Web of Science queries
* count - length of categories included in category_str (i.e., "marine" would have a count of one while "marine,terrestrial" would have a count of two), this is redundant but helpful for filtering and sorting.

**Number of rows**

Number of rows: varies

**Variable list**<br>

Number of columns: 3

**Missing data codes**<br>

There is no missing data.

**Specialized formats or other abbreviations used:**

There are no specialized formats or abbreviations used in these files.

## Data-Specific Information For: `polyp_all_ag_pubs.csv` and other remaining files described above ##

**Number of columns/variables**

* uid - Web of Science unique publication identifier (accession number)
* title - publication title
* journal_fix - publication journal with title case fixed
* journal_short - publication journal shorted to first three words
* year_fix - publication year with white space removed and as a number
* keywords_fix - publication keywords with spacing removed and separated by commas
* authors_fix - publication authors with spaces replaced with "_" and separated by commas
* environment - detailed environment category (this study)
* category - general environment category (this study)

**Number of rows**

Number of rows: varies

**Variable list**<br>

Number of columns: 9

**Missing data codes**<br>

Missing data is labeled with "NA".

**Specialized formats or other abbreviations used:**

The following abbreviations are used in these files:

* phosphorus (phos)
* microbiology (microbio)
* polyphosphate (polyp)
* polyphosphate accumulating organism (pao)
* wastewater treatment (wwt)
* As previously described in the exceptions to file naming conventions, "all" indicates a result from a search that was based on topic only and not considering a specific environment. These records could therefore include environments that were the focus of our study as well as others that were not.

There are no specialized formats used in these files.

## Data-Specific Information For: `table_s4_results.csv` ##

**Number of columns/variables**

* journal_rank - journal rank (i.e., 1 is highest rank and higher numbers indicate lower rank)
* journal_fix - journal with title case fixed
* n - number of publications (per journal) in Web of Science that are queried using the keyword "polyphospate" and are NOT represented in the five categories included in this study

**Number of rows**

Number of rows: 23

**Variable list**<br>

Number of columns: 3

**Missing data codes**<br>

There is no missing data.

**Specialized formats or other abbreviations used:**

There are no specialized formats or abbreviations used in these files.

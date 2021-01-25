# ---- script header ----
# script name: wos_data_analysis_script.R
# purpose of script: web of science data analysis
# author: sheila saia
# date created: 2020-02-07
# email: ssaia@ncsu.edu


# ---- notes ----
# notes: 

# method for setting up renv initially (by sheila saia on 2021-01-25)
# (.packages()) # to check loaded packages
# initialize R environment
# renv::init()
# for more information about renv see https://rstudio.github.io/renv/index.html
# there are additional notes on package versions and renv in the README.md file of this repository


# ---- to do ----
# to do list



# ---- 1. load libraries ----
library(tidyverse)
library(here)
library(ggforce)
library(gridExtra)
library(ggupset)
library(renv)

# if you're having trouble loading these libraries or getting the code to work
# you can activate the R environment used in this study from the renv.lock file
# you might have to adjust package settings depending on your r setup
# to activate the R environment use:
# renv::activate()
# for more information about renv see https://rstudio.github.io/renv/index.html
# there are additional notes on package versions and renv in the README.md file of this repository

# define paths
tabular_raw_data_path <- here("data", "raw_data")
tabular_processed_data_path <- here("data", "processed_data")
figure_export_path <- here("figures")


# ---- 2. load data ----
# overall paper counts data (by topic)
paper_counts_data_raw <- read_csv(paste0(tabular_raw_data_path, "/wos_topical_paper_counts_raw.csv"))

# annual wos paper counts data
paper_counts_annual_data_raw <- read_csv(paste0(tabular_raw_data_path, "/wos_annual_paper_counts_raw.csv"))

# phosphorus wos query data
phos_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "/phos_all_searches_pubs_raw.csv"))
# may give a parsing warning, which is ok. all 111856 rows are reading in ok.
# NOTE: can only download 100k at a time and can't find a way to parse phos_results so does not include "all" pubs

# microbiology wos query data
microbio_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "/microbio_all_searches_pubs_raw.csv"))
# may give a parsing warning, which is ok. all 29446 rows are reading in ok.

# polyp wos query data
polyp_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "/polyp_all_searches_pubs_raw.csv"))

# pao wos query data
pao_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "/pao_all_searches_pubs_raw.csv"))


# ---- 3. reformat/wrangle data ----
# check factor levels
class(paper_counts_data_raw$category) # character
levels(paper_counts_data_raw$category) # NULL, not right
class(paper_counts_data_raw$environment) # character
levels(paper_counts_data_raw$environment) # NULL, not right

# change factor levels of count data (order matters here and will define how they're plotted)
paper_counts_data <- paper_counts_data_raw %>%
  mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# recheck factor levels
class(paper_counts_data$category) # factor now
levels(paper_counts_data$category) # checks!
class(paper_counts_data$environment) # factor now
levels(paper_counts_data$environment) # checks!

# wrangle wos annual counts
paper_counts_annual_data <- paper_counts_annual_data_raw %>%
  mutate(wos_wide_count_millions = wos_wide_count/1000000)

# wrangle phosphorus data
phos_pubs_data <- phos_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ", " For " = " for ")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category)
# will take a second to run
# exclude "all" category for now (since can't get more than 100K entries from wos)

# wrangle microbio data
microbio_pubs_data <- microbio_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category)

# wrangle polyp data
polyp_pubs_data <- polyp_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category)

# wrangle pao data
pao_pubs_data <- pao_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category)
# exclude "all" category for now (since can't get more than 100K entries from wos)

# export for github repository
# write_csv(x = phos_pubs_data, path = paste0(tabular_processed_data_path, "/phos_all_searches_pubs.csv"))
# write_csv(x = microbio_pubs_data, path = paste0(tabular_processed_data_path, "/microbio_all_searches_pubs.csv"))
# write_csv(x = polyp_pubs_data, path = paste0(tabular_processed_data_path, "/polyp_all_searches_pubs.csv"))
# write_csv(x = pao_pubs_data, path = paste0(tabular_processed_data_path, "/pao_all_searches_pubs.csv"))

# make lists of all unique and reformated journal names for each search topic
# phosphorus journal look-up
phos_journal_lookup <- phos_pubs_data %>%
  select(journal_fix, journal_short) %>%
  distinct(journal_fix, journal_short)
# phosphorus lookup table excludes "all" category for now (since can't get more than 100K entries from wos)

# microbio journal look-up
microbio_journal_lookup <- microbio_pubs_data %>%
  select(journal_fix, journal_short) %>%
  distinct(journal_fix, journal_short)

# polyp journal look-up
polyp_journal_lookup <- polyp_pubs_data %>%
  select(journal_fix, journal_short) %>%
  distinct(journal_fix, journal_short)

# pao journal look-up
pao_journal_lookup <- pao_pubs_data %>%
  select(journal_fix, journal_short) %>%
  distinct(journal_fix, journal_short)


# ---- 4.1 calculate overall pub counts for main text and Table S2 ----
# overall counts from wos_data_retrieval_script.R (also see table S2)
phos_result_len <- 184042 # see note about 100k max pull in wos_data_retrieval_script.R
microbio_result_len <- as.numeric(dim(microbio_pubs_data_raw %>% filter(environment == "all"))[1]) # 25405
polyp_result_len <- as.numeric(dim(polyp_pubs_data_raw %>% filter(environment == "all"))[1]) # 9230
pao_result_len <- as.numeric(dim(pao_pubs_data_raw %>% filter(environment == "all"))[1]) # 797

# check counts with Table S2
phos_results_summary_counts <- phos_pubs_data_raw %>%
  ungroup() %>%
  group_by(environment) %>%
  count()
microbio_results_summary_counts <- microbio_pubs_data_raw %>%
  ungroup() %>%
  group_by(environment) %>%
  count()
polyp_results_summary_counts <- polyp_pubs_data_raw %>%
  ungroup() %>%
  group_by(environment) %>%
  count()
pao_results_summary_counts <- pao_pubs_data_raw %>%
  ungroup() %>%
  group_by(environment) %>%
  count()
# they all check!

# calculate fractions for broad categories
paper_counts_data_frac <- paper_counts_data %>%
  filter(category != "all") %>%
  group_by(keyword, category) %>%
  summarize(count_sum = sum(count)) %>%
  mutate(total_collect = if_else(keyword == "phos", phos_result_len,
                                 if_else(keyword == "microbio", microbio_result_len,
                                         if_else(keyword == "polyp", polyp_result_len, pao_result_len)))) %>%
  mutate(count_perc = round(count_sum/total_collect * 100, digits = 1),
         count_perc_text = paste0(count_perc, "%"))

# calculate fractions for specific environments
paper_counts_data_frac_envir <- paper_counts_data %>%
  filter(category != "all") %>%
  mutate(total_collect = if_else(keyword == "phos", phos_result_len,
                                 if_else(keyword == "microbio", microbio_result_len,
                                         if_else(keyword == "polyp", polyp_result_len, pao_result_len)))) %>%
  mutate(count_perc = round(count/total_collect * 100, digits = 1),
         count_perc_text = paste0(count_perc, "%"))


# ---- 4.2 plot overall pub counts (broad categories) Figure 2 ----
# define colors
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# phosphorus papers
figure2a <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "phos")) +
  geom_col(aes(x = category, y = count_sum, fill = category), color = "black") +
  geom_text(aes(x = category, y = count_sum + 2000, label = count_perc_text)) +
  xlab("") +
  ylab("Number of WOS Articles") +
  ylim(0, 60000) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 0.5, y = 60000, label = "(A) 'phosphorus' (n = 184,042)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# microbiology papers
figure2b <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "microbio")) +
  geom_col(aes(x = category, y = count_sum, fill = category), color = "black") +
  geom_text(aes(x = category, y = count_sum + 60, label = count_perc_text)) +
  xlab("") +
  ylab("") +
  ylim(0, 2000) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 0.5, y = 2000, label = "(B) 'microbiology' (n = 25,405)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# polyp papers
figure2c <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "polyp")) +
  geom_col(aes(x = category, y = count_sum, fill = category), color = "black") +
  geom_text(aes(x = category, y = count_sum + 40, label = count_perc_text)) +
  xlab("Category") +
  ylab("Number of WOS Articles") +
  ylim(0, 1250) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 0.5, y = 1200, label = "(C) 'polyphosphate' (n = 9,230)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# pao papers
figure2d <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "pao")) +
  geom_col(aes(x = category, y = count_sum, fill = category), color = "black") +
  geom_text(aes(x = category, y = count_sum + 40, label = count_perc_text)) +
  xlab("Category") +
  ylab("") +
  ylim(0, 1000) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 0.5, y = 1000, label = "(D) 'polyphosphate accumulating organisms' (n = 797)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "/figure_2.pdf"), width = 10, height = 10)
grid.arrange(figure2a, figure2b, figure2c, figure2d, nrow = 2)
dev.off()


# ---- 4.3 plot overall pub counts (specific environments) Figure S4 ----
# define colors
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# phosphorus papers
figures4a <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "phos")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 1500, label = count_perc_text)) +
  xlab("") +
  ylab("Number of WOS Articles Returned") +
  ylim(0, 45000) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 45000, label = "(A) 'phosphorus' (n = 184,042)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# microbiology papers
figures4b <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "microbio")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 35, label = count_perc_text)) +
  xlab("") +
  ylab("") +
  ylim(0, 1250) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 1250, label = "(B) 'microbiology' (n = 25,405)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# polyp papers
figures4c <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "polyp")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 35, label = count_perc_text)) +
  xlab("Environment") +
  ylab("Number of WOS Articles Returned") +
  ylim(0, 1250) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 1200, label = "(C) 'polyphosphate' (n = 9,230)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# pao papers
figures4d <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "pao")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 25, label = count_perc_text)) +
  xlab("Environment") +
  ylab("") +
  ylim(0, 800) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 800, label = "(D) 'polyphosphate accumulating organisms' (n = 797)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "/figure_s4.pdf"), width = 10, height = 10)
grid.arrange(figures4a, figures4b, figures4c, figures4d, nrow = 2)
dev.off()


# ---- 5.1 calculate paper counts over time ----
# phosphorus pubs vs time
phos_pubs_time_data <- phos_pubs_data %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(year = year_fix) %>%
  left_join(paper_counts_annual_data, by = "year") %>%
  mutate(count_frac = (n/wos_wide_count) * 100,
         count_frac_log = log10(count_frac),
         search = "phosphorus") %>%
  select(category, year, n, count_frac, count_frac_log, search)

# microbio pubs vs time
microbio_pubs_time_data <- microbio_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(year = year_fix) %>%
  left_join(paper_counts_annual_data, by = "year") %>%
  mutate(count_frac = (n/wos_wide_count) * 100,
         count_frac_log = log10(count_frac),
         search = "microbiology") %>%
  select(category, year, n, count_frac, count_frac_log, search)

# polyp pubs vs time
polyp_pubs_time_data <- polyp_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(year = year_fix) %>%
  left_join(paper_counts_annual_data, by = "year") %>%
  mutate(count_frac = (n/wos_wide_count) * 100,
         count_frac_log = log10(count_frac),
         search = "polyphosphate") %>%
  select(category, year, n, count_frac, count_frac_log, search)

# pao pubs vs time
pao_pubs_time_data <- pao_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020)  %>%
  mutate(year = year_fix) %>%
  left_join(paper_counts_annual_data, by = "year") %>%
  mutate(count_frac = (n/wos_wide_count) * 100,
         count_frac_log = log10(count_frac),
         search = "PAOs") %>%
  select(category, year, n, count_frac, count_frac_log, search)

# bind datasets
all_pubs_time_data <- bind_rows(phos_pubs_time_data, microbio_pubs_time_data, polyp_pubs_time_data, pao_pubs_time_data) %>%
  mutate(search = fct_relevel(as.character(search), "microbiology", "phosphorus", "polyphosphate", "PAOs"))

# idenfity one study in 2010s that addresses PAOs
pao_ag_data_time = pao_pubs_data %>% filter(category == "agriculture")
pao_ag_data_time$title # "Deciphering the relationship among phosphate dynamics, electron-dense body and lipid accumulation in the green alga Parachlorella kessleri"
pao_ag_data_time$year_fix # 2016
pao_ag_data_time$authors_fix # "ota_shuhei,yoshihara_mai,yamazaki_tomokazu,takeshita_tsuyoshi,hirata_aiko,konomi_mami,oshima_kenshiro,hattori_masahira,bisova_katerina,zachleder_vilem,kawano_shigeyuki"
pao_ag_data_time$journal_fix # "Scientific Reports"


# ---- 5.2 plot paper counts over time Figure S1 and Figure S2 -----
# search point shapes
my_search_shapes = c(21, 22, 23, 24)

# annual wos results overall vs time
pdf(paste0(figure_export_path, "/figure_s1.pdf"), width = 10, height = 10)
ggplot(data = paper_counts_annual_data) +
  geom_line(aes(x = year, y = wos_wide_count_millions)) +
  geom_point(aes(x = year, y = wos_wide_count_millions), shape = 21, size = 3, alpha = 0.50, color = "black", fill = "black") +
  ylim(0, 3) +
  xlab("Year") +
  ylab("Number of WOS Articles Returned from 1990-2019 (in millions)") +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))
dev.off()

# wwt results vs time
figures2a <- ggplot(data = all_pubs_time_data %>% filter(category == "wwt")) +
  geom_line(aes(x = year, y = count_frac, linetype = search)) +
  geom_point(aes(x = year, y = count_frac, shape = search), size = 3, alpha = 0.80, fill = "lightgoldenrod", color = "black") +
  annotate("text", x = 1990, y = 0.05, label = "(A) 'wwt'", size = 4, hjust = 0) +
  ylim(0, 0.05) +
  xlab("Year") +
  ylab("Percent of WOS Articles Returned from 1990-2019 (%)") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# ag results vs time
figures2b <- ggplot(data = all_pubs_time_data %>% filter(category == "agriculture")) +
  geom_line(aes(x = year, y = count_frac, linetype = search)) +
  geom_point(aes(x = year, y = count_frac, shape = search), size = 3, alpha = 0.80, fill = "sienna", color = "black") +
  annotate("text", x = 1990, y = 0.05, label = "(B) 'agriculture'", size = 4, hjust = 0) +
  ylim(0, 0.05) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# wwt results vs time (logged - base10)
figures2c <- ggplot(data = all_pubs_time_data %>% filter(category == "wwt")) +
  geom_line(aes(x = year, y = count_frac_log, linetype = search)) +
  geom_point(aes(x = year, y = count_frac_log, shape = search), size = 3, alpha = 0.80, fill = "lightgoldenrod", color = "black") +
  annotate("text", x = 1990, y = 0, label = "(C) 'wwt' logged", size = 4, hjust = 0) +
  ylim(-5, 0) +
  xlab("Year") +
  ylab("Log10 Percent of WOS Articles Returned from 1990-2019 (log10(%))") +
  scale_shape_manual(values = my_search_shapes) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# ag results vs time (logged - base10)
figures2d <- ggplot(data = all_pubs_time_data %>% filter(category == "agriculture")) +
  geom_line(aes(x = year, y = count_frac_log, linetype = search)) +
  geom_point(aes(x = year, y = count_frac_log, shape = search), size = 3, alpha = 0.80, fill = "sienna", color = "black") +
  annotate("text", x = 1990, y = 0, label = "(D) 'agriculture' logged", size = 4, hjust = 0) +
  ylim(-5, 0) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "/figure_s2.pdf"), width = 11, height = 5.5)
grid.arrange(figures2a, figures2b, figures2c, figures2d, nrow = 2)
dev.off()


# ---- 6.1 calculate journal-specific pub counts for main text and Table S4 ----
# phos pubs per journal (top journal)
phos_pubs_journal_data <- phos_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(journal_rank = dense_rank(desc(n))) %>%
  filter(journal_rank <= 5) %>%
  ungroup() %>%
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# microbio pubs per journal (top journal)
microbio_pubs_journal_data <- microbio_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(journal_rank = dense_rank(desc(n))) %>%
  filter(journal_rank <= 5) %>%
  ungroup() %>%
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# polyp pubs per journal (top journal)
polyp_pubs_journal_data <- polyp_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(journal_rank = dense_rank(desc(n))) %>%
  filter(journal_rank <= 5) %>%
  ungroup() %>%
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# polyp pubs in all category per journal (top journal)
polyp_all_pubs_journal_data <- polyp_pubs_data %>%
  filter(category == "all") %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup()  %>%
  group_by(category) %>%
  mutate(journal_rank = dense_rank(desc(n)))
# top three (lowest rank) are in polymer sciences and biochemistry

# find top journals of polyp papers that are outside the five categories
polyp_outside_pubs_lookup <- polyp_pubs_data %>%
  select(uid) %>%
  group_by(uid) %>%
  count() %>%
  filter(n == 1) %>% # if n = 1 then these should only show up in all category
  select(uid)

# use lookup to get outside pubs
polyp_outside_pubs <- polyp_pubs_data %>%
  right_join(polyp_outside_pubs_lookup, by = "uid")
# check only category should be "all"
unique(polyp_outside_pubs$category) # check

# get top 20 polyp pub journals for categories not represented in the study
polyp_outside_top20_pubs <- polyp_outside_pubs %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup()  %>%
  group_by(category) %>%
  mutate(journal_rank = dense_rank(desc(n))) %>%
  filter(journal_rank <= 20) %>%
  ungroup() %>%
  select(journal_rank, journal_fix, n)

# export for making Table S4
write_csv(polyp_outside_top20_pubs, paste0(tabular_processed_data_path, "/table_s4_results.csv"))


# ---- 7.1 calculate overlapping sets by topic ----
# phosphorus set
phos_set_data <- phos_pubs_data %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category_list = str_split(paste(category, collapse = ", "), pattern = ", "),
            category_unique = str_split(paste(unique(category), collapse = ", "), pattern = ", "), 
            category_str = paste(unlist(category_unique), collapse = ","),
            count = str_count(category_str, ",") + 1) %>%
  distinct()

# microbio set
microbio_set_data <- microbio_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category_list = str_split(paste(category, collapse = ", "), pattern = ", "),
            category_unique = str_split(paste(unique(category), collapse = ", "), pattern = ", "), 
            category_str = paste(unlist(category_unique), collapse = ","),
            count = str_count(category_str, ",") + 1) %>%
  distinct()

# polyp set
polyp_set_data <- polyp_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category_list = str_split(paste(category, collapse = ", "), pattern = ", "),
            category_unique = str_split(paste(unique(category), collapse = ", "), pattern = ", "), 
            category_str = paste(unlist(category_unique), collapse = ","),
            count = str_count(category_str, ",") + 1) %>%
  distinct()
# ag/terr/fresh WOS:000388580200045 Characteristics of phosphorus components in the sediments of main rivers into the Bohai Sea	(Shan et al. 2016)
# ag/terr (6) 
# ag/terr/wwt WOS:000366994200001 Phosphorus Recycling from an Unexplored Source by Polyphosphate Accumulating Microalgae and Cyanobacteria-A Step to Phosphorus Security in Agriculture (Mukherjee 2015)
# ag/wwt WOS:000375899200001 Deciphering the relationship among phosphate dynamics, electron-dense body and lipid accumulation in the green alga Parachlorella kessleri	(Ota et al. 2016)
# wwt/terr/fresh/marine WOS:000364520100010 Screening of Phosphorus-Accumulating Fungi and Their Potential for Phosphorus Removal from Waste Streams 
# 180 if use View(polyp_set_data) and RStudio table filter and type "terrestrial" and count > 1

# pao set
pao_set_data <- pao_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category_list = str_split(paste(category, collapse = ", "), pattern = ", "),
            category_unique = str_split(paste(unique(category), collapse = ", "), pattern = ", "), 
            category_str = paste(unlist(category_unique), collapse = ","),
            count = str_count(category_str, ",") + 1) %>%
  distinct()
# ag/wwt WOS:000375899200001 Deciphering the relationship among phosphate dynamics, electron-dense body and lipid accumulation in the green alga Parachlorella kessleri	(Ota et al. 2016)
# wwt/terr/fresh/marine WOS:000287589700005 Biological removal of phosphate from synthetic wastewater using bacterial consortium (Krishnaswamy et al. 2011)
# 21 if use View(pao_set_data) and RStudio table filter and type "terrestrial" and count > 1

# export set data for github repository
# write_csv(x = phos_set_data %>% select(uid, category_str, count), path = paste0(tabular_processed_data_path, "/phos_set_data.csv"))
# write_csv(x = microbio_set_data %>% select(uid, category_str, count), path = paste0(tabular_processed_data_path, "/microbio_set_data.csv"))
# write_csv(x = polyp_set_data %>% select(uid, category_str, count), path = paste0(tabular_processed_data_path, "/polyp_set_data.csv"))
# write_csv(x = pao_set_data %>% select(uid, category_str, count), path = paste0(tabular_processed_data_path, "/pao_set_data.csv"))


# ---- 7.2 count calculations for main text (Sections 4-7) ----
# SECTION 4
# 9230 is from Table S2
# 930 is from Table S2
# 1094 is from Table S2 (terr + mar + freshwater for polyp)

# all polyp articles in the ag category
polyp_ag_pubs_data <- polyp_pubs_data %>% 
  filter(category == "agriculture") %>%
  distinct()
dim(polyp_ag_pubs_data)[1]
# 14
# export polyp ag table
write_csv(x = polyp_ag_pubs_data, path = paste0(tabular_processed_data_path, "/polyp_all_ag_pubs.csv"))

# pao articles in the ag category
pao_ag_pubs_data <- pao_pubs_data %>% 
  filter(category == "agriculture") %>%
  distinct()
dim(pao_ag_pubs_data)[1]
# 1
# export (only one value!)
write_csv(x = pao_ag_pubs_data, path = paste0(tabular_processed_data_path, "/pao_all_ag_pubs.csv"))

# polyp wwt only papers
polyp_wwt_only_set_data <- polyp_set_data %>%
  filter(count == 1) %>%
  filter(category_list == "wwt")  %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(polyp_wwt_only_set_data)[1]
# 838
# export
write_csv(x = polyp_wwt_only_set_data, path = paste0(tabular_processed_data_path, "/polyp_wwt_only_pubs.csv"))

# pao wwt only papers
pao_wwt_only_set_data <- pao_set_data %>%
  filter(count == 1) %>%
  filter(category_list == "wwt")  %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_wwt_only_set_data)[1]
# 601
# export
write_csv(x = pao_wwt_only_set_data, path = paste0(tabular_processed_data_path, "/pao_wwt_only_pubs.csv"))

# SECTION 5
# 797 is from Table S2
# 655 is from Table S2
# 601 is from above "pao wwt only papers"
# 96 is from Table S2 (terr + mar + freshwater for pao)

# pao and polyp in terrestrial, freshwater, and marine
polyp_envir_pubs_data <- polyp_pubs_data %>%
  filter(category == "terrestrial" | category == "marine" | category == "freshwater")
pao_envir_pubs_data <- pao_pubs_data %>%
  filter(category == "terrestrial" | category == "marine" | category == "freshwater") %>%
  select(uid)
polyp_pao_envir_join_pubs_data <- polyp_envir_pubs_data %>%
  right_join(pao_envir_pubs_data, by = "uid") %>%
  distinct()
length(unique(polyp_pao_envir_join_pubs_data$uid))
# 69 papers in common
# export
write_csv(polyp_pao_envir_join_pubs_data, paste0(tabular_processed_data_path, "/polyp_pao_mar_fresh_terr_pubs.csv"))

# SECTION 6.1
# 459 is from Table S2 (soil + sed for polyp)
# 26 is from Table S2 (soil + sed for pao)
# 52192 is from Table S2 (soil + sed for phos)
# 1584 is from Table S2 (soil + sed for microbio)

# polyp in terrestrial only papers
polyp_terr_only_set_data <- polyp_set_data %>%
  filter(count == 1) %>%
  filter(map_lgl(category_list, ~ all(c("terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(polyp_terr_only_set_data)[1]
# 232
# calculate percent for main text
polyp_terr_calc_top <- dim(polyp_terr_only_set_data)[1] # 232
polyp_all_terr_pubs <- polyp_pubs_data %>% filter(category == "terrestrial")
polyp_terr_calc_bot <- length(unique(polyp_all_terr_pubs$uid)) # 412
polyp_terr_calc_top/polyp_terr_calc_bot * 100 # = 56.3%
# can't just sum soil and sediment values in Table S2 because this includes some of the same papers
# export
write_csv(x = polyp_terr_only_set_data, path = paste0(tabular_processed_data_path, "/polyp_terr_only_pubs.csv"))

# pao in terrestrial only papers
pao_terr_only_set_data <- pao_set_data %>%
  filter(count == 1) %>%
  filter(map_lgl(category_list, ~ all(c("terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_terr_only_set_data)[1]
# 5
# calculate percent for main text
pao_terr_calc_top <- dim(pao_terr_only_set_data)[1] # 5
pao_all_terr_pubs <- pao_pubs_data %>% filter(category == "terrestrial")
pao_terr_calc_bot <- length(unique(pao_all_terr_pubs$uid)) # 26
pao_terr_calc_top/pao_terr_calc_bot * 100 # = 19.2%
# can't just sum soil and sediment values in Table S2 because this includes some of the same papers
# export
write_csv(x = pao_terr_only_set_data, path = paste0(tabular_processed_data_path, "/pao_terr_only_pubs.csv"))

# TODO (check)
# polyp in terrestrial and other papers
polyp_terr_plus_other_set_data <- polyp_set_data %>%
  filter(count >= 2) %>%
  filter(map_lgl(category_list, ~ all(c("terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(polyp_terr_plus_other_set_data)[1]
# 180
# calculate percent for main text
polyp_terr_plus_calc_top <- dim(polyp_terr_plus_other_set_data)[1] # 180
polyp_all_terr_pubs <- polyp_pubs_data %>% filter(category == "terrestrial")
polyp_terr_plus_calc_bot <- length(unique(polyp_all_terr_pubs$uid)) # 412
polyp_terr_plus_calc_top/polyp_terr_plus_calc_bot * 100 # = 43.7%
# can't just sum soil and sediment values in Table S2 because this includes some of the same papers
# export
write_csv(x = polyp_terr_plus_other_set_data, path = paste0(tabular_processed_data_path, "/polyp_terr_plus_pubs.csv"))

# pao in wwt and terrestrial papers
pao_terr_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category_list, ~ all(c("wwt", "terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_terr_wwt_set_data)[1]
# 7
# export
write_csv(x = pao_terr_wwt_set_data, path = paste0(tabular_processed_data_path, "/pao_terr_wwt_pubs.csv"))

# TODO (check)
# pao in terrestrial and other papers
pao_terr_plus_other_set_data <- pao_set_data %>%
  filter(count >= 2) %>%
  filter(map_lgl(category_list, ~ all(c("terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_terr_plus_other_set_data)[1]
# 21
# export
write_csv(x = pao_terr_plus_other_set_data, path = paste0(tabular_processed_data_path, "/pao_terr_plus_pubs.csv"))

# polyp and pao overlaps by category
# terrestrial
terr_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "terrestrial") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "terrestrial") %>%
  select(-environment) %>%
  distinct()
dim(terr_polyp_pao_pubs_data)[1]
# 26
# export
write_csv(terr_polyp_pao_pubs_data, paste0(tabular_processed_data_path, "/terr_polyp_pao_pubs.csv"))

# SECTION 6.2
# 367 is from Table S2 (lake + stream + river + freshwater for polyp)
# 52 is from Table S2 (lake + stream + river + freshwater for pao)
# 36105 is from Table S2 (lake + stream + river + freshwater for phos)
# 1162 is from Table S2 (lake + stream + river + freshwater for microbio)

# polyp freshwater only papers
polyp_fresh_only_set_data <- polyp_set_data %>%
  filter(count == 1) %>%
  filter(map_lgl(category_list, ~ all(c("freshwater") %in% .x))) %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(polyp_fresh_only_set_data)[1]
# 107
# export
write_csv(polyp_fresh_only_set_data, paste0(tabular_processed_data_path, "/polyp_fresh_only_pubs.csv"))

# pao in wwt and freshwater papers
pao_fresh_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category_list, ~ all(c("wwt", "freshwater") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_fresh_wwt_set_data)[1]
# 31
# export
write_csv(pao_fresh_wwt_set_data, paste0(tabular_processed_data_path, "/pao_fresh_wwt_pubs.csv"))

# polyp and pao overlaps for freshwater papers
fresh_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "freshwater") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "freshwater") %>%
  select(-environment) %>%
  distinct()
dim(fresh_polyp_pao_pubs_data)[1]
# 45
# export
write_csv(fresh_polyp_pao_pubs_data, paste0(tabular_processed_data_path, "/fresh_polyp_pao_pubs.csv"))

# SECTION 6.3
# 367 is from Table S2 (marine + ocean + saltwater for polyp)
# 15 is from Table S2 (marine + ocean + saltwater for pao)
# 9356 is from Table S2 (marine + ocean + saltwater for phos)
# 757 is from Table S2 (marine + ocean + saltwater for microbio)

# polyp marine only papers
polyp_mar_only_set_data <- polyp_set_data %>%
  filter(count == 1) %>%
  filter(map_lgl(category_list, ~ all(c("marine") %in% .x)))  %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(polyp_mar_only_set_data)[1]
# 145
# calculate percent for main text
polyp_mar_calc_top <- dim(polyp_mar_only_set_data)[1] # 145
polyp_all_mar_pubs <- polyp_pubs_data %>% filter(category == "marine")
polyp_mar_calc_bot <- length(unique(polyp_all_mar_pubs$uid)) # 242
polyp_mar_calc_top/polyp_mar_calc_bot * 100 # = 59.9%
# can't just sum marine, ocean, and saltwater values in Table S2 because this includes some of the same papers
# export
write_csv(polyp_mar_only_set_data, paste0(tabular_processed_data_path, "/polyp_mar_only_pubs.csv"))

# pao in wwt and marine only
pao_mar_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category_list, ~ all(c("wwt", "marine") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(pao_mar_wwt_set_data)[1]
# 6
# export
write_csv(pao_mar_wwt_set_data, paste0(tabular_processed_data_path, "/pao_mar_wwt_pubs.csv"))

# polyp and pao overlaps for marine papers
mar_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "marine") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "marine") %>%
  select(-environment) %>%
  distinct()
dim(mar_polyp_pao_pubs_data)[1]
# 14
# export
write_csv(mar_polyp_pao_pubs_data, paste0(tabular_processed_data_path, "/polyp_pao_mar_pubs.csv"))

# SECTION 7
# 184042 is from Table S2
# 52192 is from Table S2 (soil + sed for phos)

# phos terrestrial only papers
phos_terr_only_set_data <- phos_set_data %>%
  filter(count == 1) %>%
  filter(map_lgl(category_list, ~ all(c("terrestrial") %in% .x)))  %>%
  select(uid) %>%
  left_join(phos_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
dim(phos_terr_only_set_data)[1]
# 32149
# export
write_csv(x = phos_terr_only_set_data, path = paste0(tabular_processed_data_path, "/phos_terr_only_pubs.csv"))

# 4429 is from Table S2
# 14 is from Tabls S2


# ---- 7.3 plot overlapping journal articles Figure 3 ----
# overlapping articles plot using ggupset
# phosphorus
figure3a <- ggplot(data = phos_set_data, aes(x = category_unique)) +
  geom_bar() +
  scale_x_upset(n_intersections = 50) +
  xlab("") +
  ylab("Number of WOS Articles") +
  ylim(0, 40000) +
  theme_classic() # +
  # annotate("text", x = 1, y = 40000, label = "(A) 'phosphorus'", size = 4, hjust = 0) # not working with scale_x_upset()

# microbio
figure3b <- ggplot(data = microbio_set_data, aes(x = category_unique)) +
  geom_bar() +
  scale_x_upset(n_intersections = 50) +
  xlab("") +
  ylab("") +
  ylim(0, 1150) +
  theme_classic() # +
  # annotate("text", x = 1, y = 1150, label = "(B) 'microbiology'", size = 4, hjust = 0) # not working with scale_x_upset()

# polyp
figure3c <- ggplot(data = polyp_set_data, aes(x = category_unique)) +
  geom_bar() +
  scale_x_upset(n_intersections = 50) +
  xlab("Category") +
  ylab("Number of WOS Articles") +
  ylim(0, 1000) +
  theme_classic() # +
  #annotate("text", x = 1, y = 1000, label = "(C) 'polyphosphate'", size = 4, hjust = 0) # not working with scale_x_upset()

# pao
figure3d <- ggplot(data = pao_set_data, aes(x = category_unique)) +
  geom_bar() +
  scale_x_upset(n_intersections = 50) +
  xlab("Category") +
  ylab("") +
  ylim(0, 700) +
  theme_classic() # +
  # annotate("text", x = 1, y = 700, label = "(D) 'polyphosphate accumulating organisms'", size = 4, hjust = 0) # not working with scale_x_upset()

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "/figure_3"), width = 15, height = 10)
grid.arrange(figure3a, figure3b, figure3c, figure3d, ncol = 2, nrow = 2)
dev.off()











# ---- delete? ----
# # pao in terr papers
# pao_all_terr_pubs <- pao_pubs_data %>%
#   filter(category == "terrestrial") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(pao_all_terr_pubs)[1]
# # 26 articles
# # export
# write_csv(x = pao_all_terr_pubs, path = paste0(tabular_processed_data_path, "/pao_all_terr_pubs.csv"))
#
# # freshwater
# # all phos articles in the fresh category
# phos_fresh_pubs_data <- phos_pubs_data %>% 
#   filter(category == "freshwater") %>%
#   distinct()
# dim(phos_fresh_pubs_data)[1]
# # 36105
# # export
# write_csv(x = phos_fresh_pubs_data, path = paste0(tabular_processed_data_path, "/phos_all_fresh_pubs.csv"))
# 
# # all microbio articles in the fresh category
# microbio_fresh_pubs_data <- microbio_pubs_data %>% 
#   filter(category == "freshwater") %>%
#   distinct()
# dim(microbio_fresh_pubs_data)[1]
# # 1162
# # export
# write_csv(x = microbio_fresh_pubs_data, path = paste0(tabular_processed_data_path, "/microbio_all_fresh_pubs.csv"))
# 
# # polyp articles in the fresh category
# polyp_fresh_pubs_data <- polyp_pubs_data %>% 
#   filter(category == "freshwater") %>%
#   distinct()
# dim(polyp_fresh_pubs_data)[1]
# # 367
# # export
# write_csv(x = polyp_fresh_pubs_data, path = paste0(tabular_processed_data_path, "/polyp_all_fresh_pubs.csv"))
# 
# # pao articles in the fresh category
# pao_fresh_pubs_data <- pao_pubs_data %>% 
#   filter(category == "freshwater") %>%
#   distinct()
# dim(pao_fresh_pubs_data)[1]
# # 52
# # export
# write_csv(x = pao_fresh_pubs_data, path = paste0(tabular_processed_data_path, "/pao_all_fresh_pubs.csv"))
# 
# # polyp in terr papers (ones in terr only as well as with other papers, see bar height on Figure 2d)
# polyp_all_terr_pubs <- polyp_pubs_data %>%
#   filter(category == "terrestrial") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(polyp_all_terr_pubs)[1]
# # 412 articles
# # NOTE: by summing soil and sediment in Table S2 we get 459
# # but some papers are repeated between the two categories so we remove repeats to get 412
# # export
# write_csv(x = polyp_terr_pubs_data, path = paste0(tabular_processed_data_path, "/polyp_all_terr_pubs.csv"))
# 
# # pao in terr papers
# pao_all_terr_pubs <- pao_pubs_data %>%
#   filter(category == "terrestrial") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(pao_all_terr_pubs)[1]
# # 26 articles
# # export
# # write_csv(x = pao_terr_pubs_data, path = paste0(tabular_processed_data_path, "/pao_all_terr_pubs.csv"))
# 
# # phos in terr papers
# phos_all_terr_pubs_data <- phos_pubs_data %>%
#   filter(category == "terrestrial") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(phos_all_terr_pubs_data)[1]
# # 26 articles
# # export
# write_csv(x = phos_terr_pubs_data, path = paste0(tabular_processed_data_path, "/phos_all_terr_pubs.csv"))
# 
# # polyp in ag and terrestrial papers
# polyp_ag_terr_set_data <- polyp_set_data %>%
#   filter(count == 2) %>%
#   filter(map_lgl(category_list, ~ all(c("agriculture", "terrestrial") %in% .x))) %>%
#   select(uid) %>%
#   left_join(polyp_pubs_data, by = "uid") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(polyp_ag_terr_set_data)[1]
# # 6
# # export
# write_csv(x = polyp_ag_terr_set_data, path = paste0(tabular_processed_data_path, "/polyp_ag_terr_pubs.csv"))
# 
# # polyp in terrestrial and freshwater papers
# polyp_terr_fresh_set_data <- polyp_set_data %>%
#   filter(map_lgl(category_list, ~ all(c("terrestrial", "freshwater") %in% .x)))
# dim(polyp_terr_fresh_set_data)[1]
# # 128
# 
# # pao in freshwater only papers
# pao_fresh_only_set_data <- pao_set_data %>%
#   filter(count == 1) %>%
#   filter(category_list == "freshwater")  %>%
#   select(uid) %>%
#   left_join(pao_pubs_data, by = "uid") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(pao_fresh_only_set_data)[1]
# # 2
# # export
# write_csv(x = pao_fresh_only_set_data, path = paste0(tabular_processed_data_path, "/pao_fresh_only_pubs.csv"))
# 
# # polyp in terr papers (ones in terr only as well as with other papers, see bar height on Figure 2d)
# polyp_all_terr_pubs <- polyp_pubs_data %>%
#   filter(category == "terrestrial") %>%
#   select(-environment, -category) %>%
#   distinct()
# dim(polyp_all_terr_pubs)[1]
# # 412 articles
# # NOTE: by summing soil and sediment in Table S2 we get 459
# # but some papers are repeated between the two categories so we remove repeats to get 412
# # export
# write_csv(x = polyp_terr_pubs_data, path = paste0(tabular_processed_data_path, "/polyp_all_terr_pubs.csv"))

# using UpSetR
# tidy_movies %>%
#   distinct(title, year, length, .keep_all=TRUE) %>%
#   unnest() %>%
#   mutate(GenreMember=1) %>%
#   spread(Genres, GenreMember, fill=0) %>%
#   as.data.frame() %>%
#   UpSetR::upset(sets = c("Action", "Romance", "Short", "Comedy", "Drama"), keep.order = TRUE)

# # using parallel sets
# data0 <- Titanic
# data1 <- reshape2::melt(Titanic)
# data2 <- gather_set_data(data1, 1:4)
# ggplot(data2, aes(x, id = id, split = y, value = value)) +
#   geom_parallel_sets(aes(fill = Sex), alpha = 0.3, axis.width = 0.1) +
#   geom_parallel_sets_axes(axis.width = 0.1) +
#   geom_parallel_sets_labels(colour = 'white')
# 
# # using ggupset
# blah0 <- tidy_movies 
# blah1 <- blah0 %>%
#   distinct(title, year, length, .keep_all=TRUE)
# ggplot(data = blah1, aes(x=Genres)) +
#   geom_bar() +
#   scale_x_upset(n_intersections = 20)
# 
# # count number of papers that overlap between searches
# phos_pubs_overlap_summary <- phos_pubs_data %>%
#   group_by(uid) %>%
#   count(name = "n_overlaps") %>%
#   ungroup()
# 
# # count number of overlapping papers
# phos_pubs_overlap_count <- phos_pubs_overlap_summary %>%
#   filter(category != "all") %>%
#   group_by(n_overlaps) %>%
#   count(name = "n_papers")
# 
# # check that lengths match
# sum(phos_pubs_overlap_count$n_papers)
# length(unique(phos_pubs_data$uid))
# 
# phos_pubs_overlap_data <- phos_pubs_data %>%
#   left_join(phos_pubs_overlap_summary, by = "uid")  %>%
#   #filter(n_overlaps > 1) %>%
#   select(uid, title, n_overlaps, environment) %>%
#   arrange(n_overlaps, uid)
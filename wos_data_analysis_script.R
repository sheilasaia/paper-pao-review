
# ---- script header ----
# script name: wos_data_analysis_script.R
# purpose of script: web of science data analysis
# author: sheila saia
# date created: 20200207
# email: ssaia@ncsu.edu


# ---- notes ----
# notes: 


# ---- to do ----
# to do list
# TODO clean up script
# TODO fix paths using here()
# TODO Theo asked if spikes were from funding cycle (3-years)?


# ---- 1. load libraries ----
library(tidyverse)
library(here)
library(ggforce)
# library(gtable)
library(gridExtra)
library(ggupset)

# define paths
# tabular_raw_data_path <- here("data")
# figure_export_path <- here() # finish this
# tabular_export_path <- here() # finish this
tabular_raw_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/raw_data/"
figure_export_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/results/figures/"
tabular_export_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/results/tabular/"

# ---- 2. load data ----
# overall paper counts data (by topic)
paper_counts_data_raw <- read_csv(paste0(tabular_raw_data_path, "wos_topical_paper_counts_raw.csv"))

# annual wos paper counts data
paper_counts_annual_data_raw <- read_csv(paste0(tabular_raw_data_path, "wos_annual_paper_counts_raw.csv"))

# phosphorus wos query data
phos_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "phos_all_searches_pubs_raw.csv"))

# microbiology wos query data
microbio_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "microbio_all_searches_pubs_raw.csv"))

# polyp wos query data
polyp_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "polyp_all_searches_pubs_raw.csv"))

# pao wos query data
pao_pubs_data_raw <- read_csv(paste0(tabular_raw_data_path, "pao_all_searches_pubs_raw.csv"))


# ---- 3. reformat/wrangle data ----
# change factor levels of count data
paper_counts_data <- paper_counts_data_raw %>%
  mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

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
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) # %>%
  #   mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  # mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #        environment = fct_relevel(environment, "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture")) # there's no "all" category yet...
# exclude "all" category for now (since can't get more than 100K entries from wos)

# wrangle microbio data
microbio_pubs_data <- microbio_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) # %>%
  #   mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  # filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  # mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #        environment = fct_relevel(environment, "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# wrangle polyp data
polyp_pubs_data <- polyp_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) # %>%
  #   mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  # filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  # mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
         # environment = fct_relevel(environment, "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# wrangle pao data
pao_pubs_data <- pao_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) # %>%
  #   mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  # filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  # mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
  #        environment = fct_relevel(environment, "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
# mutate(keywords_fix = str_replace_all(str_replace_all(str_to_lower(keywords), " ", "_"), "_\\|_", ",")) %>%
# separate(keywords_fix, into = paste("keyword_", 1:10, sep = ""), sep = ",") %>%
# select(-keywords) %>%
# group_by(uid) %>%
# gather(key = keyword_num, value = keyword, 2:11, na.rm = TRUE)

# exclude "all" category for now (since can't get more than 100K entries from wos)
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


# ---- 4.1 calculate overall pub counts ----

# get sum of counts for each category
paper_counts_data_summary <- paper_counts_data %>%
  filter(category != "all") %>% # don't want this in summary
  group_by(keyword) %>%
  summarize(count_sum = sum(count))
# phos = 110265
# microbio = 3990
# polyp = 1648
# pao = 464
# but there could totally be overlap here!

# calculate fractions for broad categories
paper_counts_data_frac <- paper_counts_data %>%
  filter(category != "all") %>%
  group_by(keyword, category) %>%
  summarize(count_sum = sum(count)) %>%
  mutate(total_collect = if_else(keyword == "phos", 184042,
                                 if_else(keyword == "microbio", 25405,
                                         if_else(keyword == "polyp", 9230, 797)))) %>%
  mutate(count_perc = round(count_sum/total_collect * 100, digits = 1),
         count_perc_text = paste0(count_perc, "%"))

# calculate fractions for specific environments
paper_counts_data_frac_envir <- paper_counts_data %>%
  filter(category != "all") %>%
  mutate(total_collect = if_else(keyword == "phos", 184042,
                                 if_else(keyword == "microbio", 25405,
                                         if_else(keyword == "polyp", 9230, 797)))) %>%
  mutate(count_perc = round(count/total_collect * 100, digits = 1),
         count_perc_text = paste0(count_perc, "%"))


# ---- 4.2 plot overall pub counts (broad categories) ----
# define colors
# my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# phosphorus papers
p11 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "phos")) +
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
p12 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "microbio")) +
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
p13 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "polyp")) +
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
p14 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "pao")) +
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
pdf(paste0(figure_export_path, "paper_counts_by_category.pdf"), width = 10, height = 10)
grid.arrange(p11, p12, p13, p14, nrow = 2)
dev.off()


# ---- 4.3 plot overall pub counts (specific environments) ----
# define colors
# my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# phosphorus papers
p1 <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "phos")) +
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
p2 <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "microbio")) +
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
p3 <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "polyp")) +
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
p4 <- ggplot(data = paper_counts_data_frac_envir %>% filter(keyword == "pao")) +
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
pdf(paste0(figure_export_path, "paper_counts_by_environment.pdf"), width = 10, height = 10)
grid.arrange(p1, p2, p3, p4, nrow = 2)
dev.off()


# ---- 5.1 calculate paper counts over time -----
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


# ---- 5.2 plot paper counts over time -----
# search point shapes
my_search_shapes = c(21, 22, 23, 24)
# my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# annual wos results overall vs time
pdf(paste0(figure_export_path, "woswide_paper_counts_vs_time.pdf"), width = 10, height = 10)
ggplot(data = paper_counts_annual_data) +
  geom_line(aes(x = year, y = wos_wide_count_millions)) +
  geom_point(aes(x = year, y = wos_wide_count_millions), shape = 21, size = 3, alpha = 0.50, color = "black", fill = "black") +
  ylim(0, 3) +
  xlab("Year") +
  ylab("Number of WOS Articles Returned from 1990-2019 (in millions)") +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))
dev.off()

# wwt results vs time
p5 <- ggplot(data = all_pubs_time_data %>% filter(category == "wwt")) +
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
p6 <- ggplot(data = all_pubs_time_data %>% filter(category == "agriculture")) +
  geom_line(aes(x = year, y = count_frac, linetype = search)) +
  geom_point(aes(x = year, y = count_frac, shape = search), size = 3, alpha = 0.80, fill = "sienna", color = "black") +
  annotate("text", x = 1990, y = 0.05, label = "(B) 'agriculture'", size = 4, hjust = 0) +
  ylim(0, 0.05) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "wwtandag_paper_counts_vs_time.pdf"), width = 10, height = 5)
grid.arrange(p5, p6, nrow = 1)
dev.off()

# wwt results vs time (logged - base10)
p5_log <- ggplot(data = all_pubs_time_data %>% filter(category == "wwt")) +
  geom_line(aes(x = year, y = count_frac_log, linetype = search)) +
  geom_point(aes(x = year, y = count_frac_log, shape = search), size = 3, alpha = 0.80, fill = "lightgoldenrod", color = "black") +
  annotate("text", x = 1990, y = 0, label = "(C) 'wwt' logged", size = 4, hjust = 0) +
  ylim(-5, 0) +
  xlab("Year") +
  ylab("Log10 Percent of WOS Articles Returned from 1990-2019 (log10(%))") +
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
p6_log <- ggplot(data = all_pubs_time_data %>% filter(category == "agriculture")) +
  geom_line(aes(x = year, y = count_frac_log, linetype = search)) +
  geom_point(aes(x = year, y = count_frac_log, shape = search), size = 3, alpha = 0.80, fill = "sienna", color = "black") +
  annotate("text", x = 1990, y = 0, label = "(D) 'agriculture' logged", size = 4, hjust = 0) +
  ylim(-5, 0) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "wwtandag_paper_counts_vs_time_log.pdf"), width = 11, height = 5.5)
grid.arrange(p5_log, p6_log, nrow = 1)
dev.off()

# plot together (un-logged and logged)
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "wwtandag_paper_counts_vs_time_log2.pdf"), width = 10, height = 10)
grid.arrange(p5, p6, p5_log, p6_log, nrow = 2)
dev.off()

# terrestrial results vs time
ggplot(data = all_pubs_time_data %>% filter(category == "terrestrial")) +
  geom_line(aes(x = year, y = count_frac, linetype = search)) +
  geom_point(aes(x = year, y = count_frac, shape = search), size = 3, alpha = 0.80, fill = "darkolivegreen3", color = "black") +
  annotate("text", x = 1990, y = 0.3, label = "(B) 'terrestrial'", size = 4, hjust = 0) +
  ylim(0, 0.3) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")


# ---- 6.1 calculate journal-specific pub counts ----
# phos pubs per jounal (top journal)
phos_pubs_journal_data <- phos_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# microbio pubs per jounal (top journal)
microbio_pubs_journal_data <- microbio_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# polyp pubs per jounal (top journal)
polyp_pubs_journal_data <- polyp_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))

# polyp pubs in all category per journal (top journal)
polyp_all_pubs_journal_data <- polyp_pubs_data %>%
  filter(category == "all") %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup()  %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n)))
# top three are in polymer sciences and biochemistry

# find top journals of polyp papers that are outside the five categories (for table SX)
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
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 20) %>%
  ungroup() %>%
  select(pub_rank, journal_fix, n)

# export for making table SX
write_csv(polyp_outside_top20_pubs, paste0(tabular_export_path, "polyp_outside_top20_pubs.csv"))

# pao pubs per jounal (top journal)
pao_pubs_journal_data <- pao_pubs_data %>%
  filter(category != "all") %>% # exclude "all" category for now
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwt", "terrestrial", "freshwater", "marine", "agriculture"))


# ---- 6.2 plot journal-specific pub counts ----
# define colors
# my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# microbiology results
ggplot(data = microbio_pubs_journal_data) +
  geom_col(aes(x = journal_fix, y = n, fill = category), color = "black") +
  xlab("Journal") +
  ylab("Number of WOS Articles Returned") +
  scale_fill_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))


# ---- 7.1 author counts ----
# phosphorus
phos_author_data <- phos_pubs_data %>%
  select(uid, category, environment, authors_fix) %>%
  mutate(authors_count = str_count(authors_fix, ',') + 1, 
         authors_list = str_split(authors_fix, ',')) %>%
  unnest(authors_list) %>%
  separate(authors_list, c("last_name", "first_name"), "_") %>%
  mutate(first_name_fix = str_sub(first_name, start = 1, end = 1), 
         full_name = paste0(last_name, ", ", first_name_fix)) %>%
  select(uid, category, environment, authors_count, authors_fix, full_name)

# count number of articles per author per environment
phos_author_pub_count_data <- phos_author_data %>%
  group_by(category, full_name) %>%
  count() %>% 
  ungroup() %>%
  group_by(category) %>%
  mutate(author_rank = dense_rank(desc(n))) #%>%
  # filter(author_rank <= 2) %>%
  # ungroup()

# paos
pao_author_data <- pao_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category, environment, authors_fix) %>%
  mutate(authors_count = str_count(authors_fix, ',') + 1, 
         authors_list = str_split(authors_fix, ',')) %>%
  unnest(authors_list) %>%
  separate(authors_list, c("last_name", "first_name"), "_") %>%
  mutate(first_name_fix = str_sub(first_name, start = 1, end = 1), 
         full_name = paste0(last_name, ", ", first_name_fix)) %>%
  select(uid, category, environment, authors_count, authors_fix, full_name)

# count number of articles per author per environment
pao_author_pub_count_data <- pao_author_data %>%
  group_by(category, full_name) %>%
  count() %>% 
  ungroup() %>%
  group_by(category) %>%
  mutate(author_rank = dense_rank(desc(n))) # %>%
  # filter(author_rank <= 1) %>%
  # ungroup()


# ---- 8.x looking at general categories of articles ----

# all polyp articles in the ag category
polyp_ag_pubs_data <- polyp_pubs_data %>% 
  filter(category == "agriculture")
# export polyp ag table
write_csv(polyp_ag_pubs_data, paste0(tabular_export_path, "polyp_all_ag_pubs.csv"))

# pao articles in the ag category
pao_ag_pubs_data <- pao_pubs_data %>% 
  filter(category == "agriculture")
# ota et al. 2016

# ---- 8.1 calculate overlapping journal articles ----
# phosphorus
phos_set_data <- phos_pubs_data %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = str_split(paste(unique(category), collapse = ", "), pattern = ", "), 
            count = n()) #%>%
  # filter(count > 1)

# 30,817 if i select "terrestrial" and = 1
  
# microbio
microbio_set_data <- microbio_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = str_split(paste(category, collapse = ", "), pattern = ", "), 
            count = n()) #%>%
  # filter(count > 1)

# polyp
polyp_set_data <- polyp_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = str_split(paste(category, collapse = ", "), pattern = ", "), 
            count = n()) #%>%
  # filter(count > 1)
# ag/terr/fresh WOS:000388580200045 Characteristics of phosphorus components in the sediments of main rivers into the Bohai Sea	(Shan et al. 2016)
# ag/terr (6) 
# ag/terr/wwt WOS:000366994200001 Phosphorus Recycling from an Unexplored Source by Polyphosphate Accumulating Microalgae and Cyanobacteria-A Step to Phosphorus Security in Agriculture (Mukherjee 2015)
# ag/wwt WOS:000375899200001 Deciphering the relationship among phosphate dynamics, electron-dense body and lipid accumulation in the green alga Parachlorella kessleri	(Ota et al. 2016)
# wwt/terr/fresh/marine WOS:000364520100010 Screening of Phosphorus-Accumulating Fungi and Their Potential for Phosphorus Removal from Waste Streams 

# 98 if i select "terrestrial" and > 1

# pao
pao_set_data <- pao_pubs_data %>%
  filter(category != "all") %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = str_split(paste(category, collapse = ", "), pattern = ", "), 
            count = n()) %>%
  distinct()
# filter(count > 1)
# pao_set_data_v2 <- pao_pubs_data %>%
#   filter(category != "all") %>%
#   select(uid, category) %>%
#   group_by(uid) 
# ag/wwt WOS:000375899200001 Deciphering the relationship among phosphate dynamics, electron-dense body and lipid accumulation in the green alga Parachlorella kessleri	(Ota et al. 2016)
# wwt/terr/fresh/marine WOS:000287589700005 Biological removal of phosphate from synthetic wastewater using bacterial consortium (Krishnaswamy et al. 2011)

# 21 if i select "terrestrial" and > 1




# polyp in ag and terrestrial
polyp_ag_terr_set_data <- polyp_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category, ~ all(c("agriculture", "terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# export
write_csv(polyp_ag_terr_set_data, paste0(tabular_export_path, "polyp_ag_terr_only_pubs.csv"))

# polyp in terrestrial only
polyp_terr_only_set_data <- polyp_set_data %>%
  filter(category == "terrestrial") %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 221
221/459 # 48.1%
# export
write_csv(polyp_terr_only_set_data, paste0(tabular_export_path, "polyp_terr_only_pubs.csv"))

# polyp in terrestrial and freshwater only
polyp_terr_fresh_set_data <- polyp_set_data %>%
  filter(count == 2)

# polyp freshwater only
polyp_fresh_set_data <- polyp_set_data %>%
  filter(category == "freshwater") %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 87
# export
write_csv(polyp_fresh_set_data, paste0(tabular_export_path, "polyp_fresh_only_pubs.csv"))

# polyp marine only
polyp_mar_set_data <- polyp_set_data %>%
  filter(category == "marine")  %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
128/367 # = 34.9%
# export
write_csv(polyp_mar_set_data, paste0(tabular_export_path, "polyp_mar_only_pubs.csv"))

# polyp wwt only
polyp_wwt_set_data <- polyp_set_data %>%
  filter(category == "wwt")  %>%
  select(uid) %>%
  left_join(polyp_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 838
# export
write_csv(polyp_wwt_set_data, paste0(tabular_export_path, "polyp_wwt_only_pubs.csv"))





# pao in terr only
pao_terr_set_data <- pao_pubs_data %>%
  filter(category == "terrestrial") %>%
  select(-environment, -category) %>%
  distinct()
# 26 articles
26/671 #= 3.9%
# export
write_csv(pao_terr_set_data, paste0(tabular_export_path, "pao_terr_only_pubs.csv"))


# pao wwt only
pao_wwt_set_data <- pao_set_data %>%
  filter(category == "wwt")  %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 601
# export
write_csv(pao_wwt_set_data, paste0(tabular_export_path, "pao_wwt_only_pubs.csv"))

# pao in wwt and terrestrial only
pao_terr_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category, ~ all(c("wwt", "terrestrial") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 7!
# export
write_csv(pao_terr_wwt_set_data, paste0(tabular_export_path, "pao_terr_wwt_only_pubs.csv"))

# pao in freshwater only
pao_fresh_set_data <- pao_set_data %>%
  filter(category == "freshwater")  %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 2
# export
write_csv(pao_fresh_set_data, paste0(tabular_export_path, "pao_fresh_only_pubs.csv"))

# pao in wwt and freshwater only
pao_fresh_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category, ~ all(c("wwt", "freshwater") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# export
write_csv(pao_fresh_wwt_set_data, paste0(tabular_export_path, "pao_fresh_wwt_only_pubs.csv"))

# pao in wwt and marine only
pao_mar_wwt_set_data <- pao_set_data %>%
  filter(count == 2) %>%
  filter(map_lgl(category, ~ all(c("wwt", "marine") %in% .x))) %>%
  select(uid) %>%
  left_join(pao_pubs_data, by = "uid") %>%
  select(-environment, -category) %>%
  distinct()
# 6!
# export
write_csv(pao_mar_wwt_set_data, paste0(tabular_export_path, "pao_mar_wwt_only_pubs.csv"))

# polyp and pao overlaps by category
# terrestrial
terr_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "terrestrial") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "terrestrial") %>%
  select(-environment) %>%
  distinct()
length(unique(terr_polyp_pao_pubs_data$uid)) #26
# export
write_csv(terr_polyp_pao_pubs_data, paste0(tabular_export_path, "terr_polyp_pao_pubs.csv"))

# polyp and pao overlaps by category
# freshwater
fresh_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "freshwater") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "freshwater") %>%
  select(-environment) %>%
  distinct()
length(unique(fresh_polyp_pao_pubs_data$uid)) #45
# export
write_csv(fresh_polyp_pao_pubs_data, paste0(tabular_export_path, "fresh_polyp_pao_pubs.csv"))

# polyp and pao overlaps by category
# marine
mar_polyp_pao_pubs_data <- polyp_pubs_data %>%
  filter(category == "marine") %>%
  select(uid) %>%
  right_join(pao_pubs_data, by = "uid") %>%
  filter(category == "marine") %>%
  select(-environment) %>%
  distinct()
length(unique(mar_polyp_pao_pubs_data$uid)) #14
# export
write_csv(mar_polyp_pao_pubs_data, paste0(tabular_export_path, "mar_polyp_pao_pubs.csv"))



# keep_col <- sum(unlist(pao_terr_wwt_set_data$category) %in% c("wwt", "terrestrial"))
# pao_terr_wwt_set_data <- pao_set_data_v2 %>%
#   filter(category == "wwt" | category == "terrestrial")
# filter(count == 2)
# keep_list <- unlist(pao_terr_wwt_set_data$category) %in% c("wwt", "terrestrial")
# pao_terr_wwt_set_data$keep_list <- keep_list

# pao and polyp in terrestrial, freshwater, and marine
polyp_envir_pubs_data <- polyp_pubs_data %>%
  filter(category == "terrestrial" | category == "marine" | category == "freshwater")
pao_envir_pubs_data <- pao_pubs_data %>%
  filter(category == "terrestrial" | category == "marine" | category == "freshwater") %>%
  select(uid)
polyp_pao_envir_join_pubs_data <- polyp_envir_pubs_data %>%
  right_join(pao_envir_pubs_data, by = "uid")
length(unique(polyp_pao_envir_join_pubs_data$uid)) # 69 papers in common

# plot
p7 <- ggplot(data = phos_set_data, aes(x = category)) +
  geom_bar() +
  # geom_text(stat = 'count', aes(label = ..count..), vjust = -1) +
  xlab("") +
  ylab("Number of WOS Articles") +
  ylim(0, 40000) +
  theme_classic() +
  annotate("text", x = 1, y = 40000, label = "(A) 'phosphorus'", size = 4, hjust = 0) +
  scale_x_upset()

p8 <- ggplot(data = microbio_set_data, aes(x = category)) +
  geom_bar() +
  xlab("") +
  ylab("") +
  ylim(0, 1000) +
  theme_classic() +
  annotate("text", x = 1, y = 1000, label = "(B) 'microbiology'", size = 4, hjust = 0) +
  scale_x_upset()

p9 <- ggplot(data = polyp_set_data, aes(x = category)) +
  geom_bar() +
  xlab("Category") +
  ylab("Number of WOS Articles") +
  ylim(0, 1000) +
  theme_classic() +
  annotate("text", x = 1, y = 1000, label = "(C) 'polyphosphate'", size = 4, hjust = 0) +
  scale_x_upset()

p10 <- ggplot(data = pao_set_data, aes(x = category)) +
  geom_bar() +
  xlab("Category") +
  ylab("") +
  ylim(0, 700) +
  theme_classic() +
  annotate("text", x = 1, y = 700, label = "(D) 'polyphosphate accumulating organisms'", size = 4, hjust = 0) +
  scale_x_upset()

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
pdf(paste0(figure_export_path, "overlapping_papers.pdf"), width = 15, height = 10)
grid.arrange(p7, p8, p9, p10, ncol = 2, nrow = 2)
dev.off()








# using UpSetR
# tidy_movies %>%
#   distinct(title, year, length, .keep_all=TRUE) %>%
#   unnest() %>%
#   mutate(GenreMember=1) %>%
#   spread(Genres, GenreMember, fill=0) %>%
#   as.data.frame() %>%
#   UpSetR::upset(sets = c("Action", "Romance", "Short", "Comedy", "Drama"), keep.order = TRUE)

# using parallel sets
data0 <- Titanic
data1 <- reshape2::melt(Titanic)
data2 <- gather_set_data(data1, 1:4)
ggplot(data2, aes(x, id = id, split = y, value = value)) +
  geom_parallel_sets(aes(fill = Sex), alpha = 0.3, axis.width = 0.1) +
  geom_parallel_sets_axes(axis.width = 0.1) +
  geom_parallel_sets_labels(colour = 'white')

# using ggupset
blah0 <- tidy_movies 
blah1 <- blah0 %>%
  distinct(title, year, length, .keep_all=TRUE)
ggplot(data = blah1, aes(x=Genres)) +
  geom_bar() +
  scale_x_upset(n_intersections = 20)

# count number of papers that overlap between searches
phos_pubs_overlap_summary <- phos_pubs_data %>%
  group_by(uid) %>%
  count(name = "n_overlaps") %>%
  ungroup()

# count number of overlapping papers
phos_pubs_overlap_count <- phos_pubs_overlap_summary %>%
  filter(category != "all") %>%
  group_by(n_overlaps) %>%
  count(name = "n_papers")

# check that lengths match
sum(phos_pubs_overlap_count$n_papers)
length(unique(phos_pubs_data$uid))

phos_pubs_overlap_data <- phos_pubs_data %>%
  left_join(phos_pubs_overlap_summary, by = "uid")  %>%
  #filter(n_overlaps > 1) %>%
  select(uid, title, n_overlaps, environment) %>%
  arrange(n_overlaps, uid)


# ---- 9.1 anti-join for pao and polyp pubs ----
# polyp
polyp_all_titles <- polyp_pubs_data %>%
  filter(category == "all") %>%
  select(uid, title, journal_fix, keywords_fix)
polyp_specific_titles <- polyp_pubs_data %>%
  filter(category != "all") %>%
  distinct(uid)
polyp_anti_titles <- anti_join(polyp_all_titles, polyp_specific_titles, by = "uid")
polyp_anti_journals <- polyp_anti_titles %>%
  distinct(journal_fix)

#paos
pao_all_titles <- pao_pubs_data %>%
  filter(category == "all") %>%
  select(uid, title, journal_fix, keywords_fix)
pao_specific_titles <- pao_pubs_data %>%
  filter(category != "all") %>%
  distinct(uid)
pao_anti_titles <- anti_join(pao_all_titles, pao_specific_titles, by = "uid")
pao_anti_journals <- pao_anti_titles %>%
  distinct(journal_fix)

# export to send to jay
write_csv(x = polyp_anti_titles, path = paste0(here(), "/results/", "polyp_antijoin_titles.csv"))
write_csv(x = polyp_anti_journals, path = paste0(here(), "/results/", "polyp_antijoin_unique_journals.csv"))
write_csv(x = pao_anti_titles, path = paste0(here(), "/results/", "pao_antijoin_titles.csv"))
write_csv(x = pao_anti_journals, path = paste0(here(), "/results/", "pao_antijoin_unique_journals.csv"))


# ---- 10.1 dendogram ----
# https://www.r-graph-gallery.com/340-custom-your-dendrogram-with-dendextend.html
# mtcars %>% 
#   select(mpg, cyl, disp) %>% 
#   dist() %>% 
#   hclust() %>% 
#   as.dendrogram() -> dend
# # plot
# par(mar=c(7,3,1,1))  # Increase bottom margin to have the complete label
# plot(dend)

# polyp
polyp_dendo_data <- polyp_pubs_data %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = paste(unique(category), collapse = ", "))

# pao
pao_dendo_data <- pao_pubs_data %>%
  select(uid, category) %>%
  group_by(uid) %>%
  summarize(category = paste(unique(category), collapse = ", ")) 

# export data for hunter
write_csv(polyp_dendo_data, paste0("polyp_dendogram_data.csv"))
write_csv(pao_dendo_data, paste0("pao_dendogram_data.csv"))

# rownames(test) <- test$uid
# test2 <- test %>% select (-uid)
# 
# dist_matrix <- test2[1:100,] %>%
#   dist()
# 
# dend <- dist_matrix %>%
#   hclust() %>%
#   as.dendrogram()


# ---- TO DO LIST ----



# ---- X.1 calculate paper count fraction ----
# wrangle data to divide by polyP and PAOs by microbiology keywords
paper_counts_perc_data <- paper_counts_data_raw %>%
  pivot_wider(names_from = keyword, values_from = count) %>%
  mutate(polyp_perc = polyp/microbio * 100,
         pao_perc = pao/microbio * 100) %>%
  select(environment, category, polyp_perc, pao_perc) %>%
  pivot_longer(cols = c(polyp_perc, pao_perc), names_to = "keyword", values_to = "count_perc") %>%
  mutate(category = fct_relevel(category, "all", "wwt", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwt", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"),
         keyword_recode = recode_factor(keyword, "polyp_perc" = "polyP", "pao_perc" = "PAO"))


# ---- X.2 plot paper count fraction ----
my_category_colors <- c("white", "darkgoldenrod2", "darkolivegreen3", "lightskyblue", "darkcyan", "darkorange")
ggplot(data = paper_counts_perc_data) +
  geom_col(aes(x = environment, y = count_perc, fill = category), color = "black") +
  facet_wrap(~keyword_recode) +
  xlab("Environment") +
  ylab("Number of Results Relative to 'microbiology' Search") +
  scale_fill_manual(values = my_category_colors) +
  theme_bw() +
  theme(
    plot.background = element_blank(),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(color = 'black'),
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) #+
#facet_zoom(ylim = c(0, 100))




# wrangle
polyp_pubs <- polyp_pubs_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of" = " of", " The" = " the", "And" = "and", "&" = "and", "In" = "in")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") > 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, journal_fix, journal_short, year_fix, keywords_fix, authors_fix)

# summarize counts by year
polyp_pubs_yearly_counts <- polyp_pubs %>%
  group_by(year_fix) %>%
  count()

# summarize counts by journal
polyp_pubs_journal_counts <- polyp_pubs %>%
  group_by(journal_fix, journal_short) %>% # check that number of rows doesn't change without journal_short here
  count()

# box plot of pubs per year
ggplot(data = polyp_pubs_yearly_counts) +
  geom_col(aes(x = year_fix, y = n)) +
  xlab("Year") +
  ylab("Number of WOS Articles w/ Keyword 'polyphosphate' Published") +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))

# box plot of pubs per journal
polyp_pubs_journal_counts %>%
  ungroup() %>%
  mutate(journal_short = fct_reorder(journal_short, desc(n))) %>%
  filter(n > 1) %>%
  ggplot() +
  geom_col(aes(x = journal_short, y = n)) +
  ylim(0, 11) +
  xlab("Journal Name") +
  ylab("Number of WOS Articles w/ Keyword 'polyphosphate' Published") +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 10),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))








result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND DT = Article", editions = c("SCI")) # 759 hits
result <- wos_search(sid, "((TS=(polyphosphate AND soil)) AND (DT=Article))", editions = "SCI") # 272 hits
result <- wos_search(sid, "((TS=('polyphosphate accumulating organisms' AND soil)) AND (DT=Article))", editions = "SCI") # 16 hits
result <- wos_search(sid, "((TS=('polyphosphate accumulating organisms' AND marine)) AND (DT=Article))", editions = "SCI") # 6 hits
result <- wos_search(sid, "((TS=('polyphosphate accumulating organisms' AND agriculture)) AND (DT=Article))", editions = "SCI") # 1 hits

# look at journal counts
pao_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND DT = Article", editions = c("SCI"))
# 759 hits

pao_pubs <- wos_retrieve_all(pao_result)

pao_pub_counts <- pao_pubs %>%
  group_by(journal) %>%
  summarize(count = n()) %>%
  arrange(count) %>%
  filter(count > 5) 

pao_pubs_keywords <- pao_pubs %>%
  select(uid, keywords) %>%
  mutate(keywords_fix = str_replace_all(str_replace_all(str_to_lower(keywords), " ", "_"), "_\\|_", ",")) %>%
  separate(keywords_fix, into = paste("keyword_", 1:10, sep = ""), sep = ",") %>%
  select(-keywords) %>%
  group_by(uid) %>%
  gather(key = keyword_num, value = keyword, 2:11, na.rm = TRUE)

empty_keyword_pubs <- pao_pubs_keywords %>%
  filter(keyword == "")

non_empty_keyword_pubs <- pao_pubs_keywords %>%
  filter(keyword != "")

keyword_counts <- non_empty_keyword_pubs %>%
  ungroup() %>%
  group_by(keyword) %>%
  summarize(counts = n())


# plot counts per journal
ggplot(data = pao_pub_counts) +
  geom_col(aes(y = count, x = fct_reorder(journal, count, .desc = TRUE))) +
  xlab("Journals with > 10 Records") +
  ylab("Count WOS Articles with 'Polyphosphate Accumulating Organisms'") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))


# result <- wos_search(sid, "TS='environmental justice' AND DT = Article", editions = c("SCI")) # 1695 hits
# result <- wos_search(sid, "TS='environmental justice' AND TS='water quality' AND DT = Article", editions = c("SCI")) # 56 hits


# ---- X.3 plot of counts per time ----


# define colors
my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# microbio pubs vs time
ggplot(data = microbio_pubs_time_data) +
  geom_col(aes(x = year_fix, y = n, fill = category), color = "black") +
  facet_wrap(~ category) +
  xlab("Year") +
  ylab("Number of WOS 'microbiology' Articles Returned (after 1990)") +
  scale_fill_manual(values = my_category_colors_all) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# polyp pubs vs time
ggplot(data = polyp_pubs_time_data) +
  geom_col(aes(x = year_fix, y = n, fill = category), color = "black") +
  facet_wrap(~ category) +
  xlab("Year") +
  ylab("Number of WOS 'polyphosphate' Articles Returned (after 1990)") +
  scale_fill_manual(values = my_category_colors_all) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# pao pubs vs time
ggplot(data = pao_pubs_time_data) +
  geom_col(aes(x = year_fix, y = n, fill = category), color = "black") +
  facet_wrap(~ category) +
  xlab("Year") +
  ylab("Number of WOS 'polyphosphate accumulating organisms' Articles Returned") +
  scale_fill_manual(values = my_category_colors_all) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot all together (without 'all' category)
ggplot(data = all_pubs_time_data %>% filter(category != "all")) +
  geom_line(aes(x = year_fix, y = n, color = category, linetype = search)) +
  geom_point(aes(x = year_fix, y = n, color = category, shape = search), size = 3, alpha = 0.80) +
  facet_wrap(~ category) +
  xlab("Year") +
  ylab("Number of WOS Articles Returned (between 1990-2019)") +
  scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))

# plot all together (just 'all' category)
ggplot(data = all_pubs_time_data %>% filter(category == "all")) +
  geom_line(aes(x = year_fix, y = n, linetype = search)) +
  geom_point(aes(x = year_fix, y = n, shape = search), size = 3, alpha = 0.80) +
  xlab("Year") +
  ylab("Number of WOS Articles Returned") +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))
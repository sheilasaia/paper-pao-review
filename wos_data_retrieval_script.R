# web of science meta-analysis

# ---- 1. load libraries ----
# install.packages("devtools")  # if required
# devtools::install_github("juba/rwos")
library(rwos)
library(tidyverse)
library(here)

# define paths 
# tabular_raw_data_path <- here("data", "tabular", "wos_raw_data")
tabular_raw_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/raw_data/" # (use hardcoding for now)

# rwos docs
# https://github.com/juba/rwos

# options: "SCI", "IC", "ISTP", "ISSHP"
# USFS only authorized for "SCI"
# http://help.incites.clarivate.com/inCites2Live/dataAndSubscriptionNotificationsGroup/dataAndSubsNotice.html


# ---- 2. initiate wos session ----
# get session identifier
sid <- wos_authenticate()


# ---- 3. "microbiology" search ----
# as of 20200211 at 12pm

# search for articles
microbio_result <- wos_search(sid, "TS='microbiology' AND DT = Article", editions = c("SCI")) # 25283 results found
microbio_wwtp_result <- wos_search(sid, "TS='microbiology' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 274
microbio_soil_result <- wos_search(sid, "TS='microbiology' AND TS='soil' AND DT = Article", editions = c("SCI")) # 1135
microbio_sed_result <- wos_search(sid, "TS='microbiology' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 441
microbio_lake_result <- wos_search(sid, "TS='microbiology' AND TS='lake' AND DT = Article", editions = c("SCI")) # 186
microbio_stream_result <- wos_search(sid, "TS='microbiology' AND TS='stream' AND DT = Article", editions = c("SCI")) # 518
microbio_river_result <- wos_search(sid, "TS='microbiology' AND TS='river' AND DT = Article", editions = c("SCI")) # 183
microbio_fw_result <- wos_search(sid, "TS='microbiology' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 261
microbio_marine_result <- wos_search(sid, "TS='microbiology' AND TS='marine' AND DT = Article", editions = c("SCI")) # 485
microbio_ocean_result <- wos_search(sid, "TS='microbiology' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 167
microbio_sw_result <- wos_search(sid, "TS='microbiology' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 103
microbio_ag_result <- wos_search(sid, "TS='microbiology' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 219

# retrieve pub info
# microbio_pubs_raw <- wos_retrieve(microbio_result, count = 200)
microbio_pubs_raw <- wos_retrieve_all(microbio_result) %>% mutate(category = "all") # will pull all records
microbio_wwtp_pubs_raw <- wos_retrieve_all(microbio_wwtp_result) %>% mutate(category = "wwtp")
microbio_soil_pubs_raw <- wos_retrieve_all(microbio_soil_result) %>% mutate(category = "soil")
microbio_sed_pubs_raw <- wos_retrieve_all(microbio_sed_result) %>% mutate(category = "sediment")
microbio_lake_pubs_raw <- wos_retrieve_all(microbio_lake_result) %>% mutate(category = "lake")
microbio_stream_pubs_raw <- wos_retrieve_all(microbio_stream_result) %>% mutate(category = "stream")
microbio_river_pubs_raw <- wos_retrieve_all(microbio_river_result) %>% mutate(category = "river")
microbio_marine_pubs_raw <- wos_retrieve_all(microbio_marine_result) %>% mutate(category = "marine")
microbio_ocean_pubs_raw <- wos_retrieve_all(microbio_ocean_result) %>% mutate(category = "ocean")
microbio_sw_pubs_raw <- wos_retrieve_all(microbio_sw_result) %>% mutate(category = "sw")
microbio_ag_pubs_raw <- wos_retrieve_all(microbio_ag_result) %>% mutate(category = "ag")

# export raw data for future reading in
write_csv(x = microbio_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_pubs_raw.csv"))
write_csv(x = microbio_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_wwtp_pubs_raw.csv"))
write_csv(x = microbio_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_soil_pubs_raw.csv"))
write_csv(x = microbio_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_sed_pubs_raw.csv"))
write_csv(x = microbio_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_lake_pubs_raw.csv"))
write_csv(x = microbio_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_stream_pubs_raw.csv"))
write_csv(x = microbio_river_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_river_pubs_raw.csv"))
write_csv(x = microbio_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_marine_pubs_raw.csv"))
write_csv(x = microbio_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_ocean_pubs_raw.csv"))
write_csv(x = microbio_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_sw_pubs_raw.csv"))
write_csv(x = microbio_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_ag_pubs_raw.csv"))

# bind rows
microbio_all_searches_pubs_raw <- bind_rows(microbio_pubs_raw, microbio_wwtp_pubs_raw,
                                            microbio_soil_pubs_raw, microbio_sed_pubs_raw,
                                            microbio_lake_pubs_raw, microbio_stream_pubs_raw,
                                            microbio_river_pubs_raw, microbio_marine_pubs_raw,
                                            microbio_ocean_pubs_raw, microbio_sw_pubs_raw,
                                            microbio_ag_pubs_raw)

# export full dataset
write_csv(x = microbio_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "microbio_all_searches_pubs_raw.csv"))


# ---- 4. "polyphosphate" search ----
# as of 20200211 at 12pm

# search for articles
polyp_result <- wos_search(sid, "TS='polyphosphate' AND DT = Article", editions = c("SCI")) # 9180 results found
polyp_wwtp_result <- wos_search(sid, "TS='polyphosphate' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 540
polyp_soil_result <- wos_search(sid, "TS='polyphosphate' AND TS='soil' AND DT = Article", editions = c("SCI")) # 287
polyp_sed_result <- wos_search(sid, "TS='polyphosphate' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 169
polyp_lake_result <- wos_search(sid, "TS='polyphosphate' AND TS='lake' AND DT = Article", editions = c("SCI"))# 159
polyp_stream_result <- wos_search(sid, "TS='polyphosphate' AND TS='stream' AND DT = Article", editions = c("SCI")) # 61
polyp_river_result <- wos_search(sid, "TS='polyphosphate' AND TS='river' AND DT = Article", editions = c("SCI")) # 43
polyp_fw_result <- wos_search(sid, "TS='polyphosphate' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 102
polyp_marine_result <- wos_search(sid, "TS='polyphosphate' AND TS='marine' AND DT = Article", editions = c("SCI")) # 135
polyp_ocean_result <- wos_search(sid, "TS='polyphosphate' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 32
polyp_sw_result <- wos_search(sid, "TS='polyphosphate' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 94
polyp_ag_result <- wos_search(sid, "TS='polyphosphate' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 14

# retrieve pub info
# polyp_pubs_raw <- wos_retrieve(polyp_result, count = 200)
polyp_pubs_raw <- wos_retrieve_all(polyp_result) %>% mutate(category = "all") # will pull all records
polyp_wwtp_pubs_raw <- wos_retrieve_all(polyp_wwtp_result) %>% mutate(category = "wwtp")
polyp_soil_pubs_raw <- wos_retrieve_all(polyp_soil_result) %>% mutate(category = "soil")
polyp_sed_pubs_raw <- wos_retrieve_all(polyp_sed_result) %>% mutate(category = "sediment")
polyp_lake_pubs_raw <- wos_retrieve_all(polyp_lake_result) %>% mutate(category = "lake")
polyp_stream_pubs_raw <- wos_retrieve_all(polyp_stream_result) %>% mutate(category = "stream")
polyp_river_pubs_raw <- wos_retrieve_all(polyp_river_result) %>% mutate(category = "river")
polyp_marine_pubs_raw <- wos_retrieve_all(polyp_marine_result) %>% mutate(category = "marine")
polyp_ocean_pubs_raw <- wos_retrieve_all(polyp_ocean_result) %>% mutate(category = "ocean")
polyp_sw_pubs_raw <- wos_retrieve_all(polyp_sw_result) %>% mutate(category = "sw")
polyp_ag_pubs_raw <- wos_retrieve_all(polyp_ag_result) %>% mutate(category = "ag")

# export raw data for future reading in
write_csv(x = polyp_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_pubs_raw.csv"))
write_csv(x = polyp_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_wwtp_pubs_raw.csv"))
write_csv(x = polyp_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_soil_pubs_raw.csv"))
write_csv(x = polyp_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_sed_pubs_raw.csv"))
write_csv(x = polyp_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_lake_pubs_raw.csv"))
write_csv(x = polyp_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_stream_pubs_raw.csv"))
write_csv(x = polyp_river_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_river_pubs_raw.csv"))
write_csv(x = polyp_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_marine_pubs_raw.csv"))
write_csv(x = polyp_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_ocean_pubs_raw.csv"))
write_csv(x = polyp_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_sw_pubs_raw.csv"))
write_csv(x = polyp_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_ag_pubs_raw.csv"))

# bind rows
polyp_all_searches_pubs_raw <- bind_rows(polyp_pubs_raw, polyp_wwtp_pubs_raw,
                                         polyp_soil_pubs_raw, polyp_sed_pubs_raw,
                                         polyp_lake_pubs_raw, polyp_stream_pubs_raw,
                                         polyp_river_pubs_raw, polyp_marine_pubs_raw,
                                         polyp_ocean_pubs_raw, polyp_sw_pubs_raw,
                                         polyp_ag_pubs_raw)

# export full dataset
write_csv(x = polyp_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "polyp_all_searches_pubs_raw.csv"))


# ---- 5. "polyphosphate accumulating organisms" search ----
# as of 20200211 at 12pm

# search for articles
pao_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND DT = Article", editions = c("SCI")) # 789 results found
pao_wwtp_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 366
pao_soil_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='soil' AND DT = Article", editions = c("SCI")) # 18
pao_sed_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 11
pao_lake_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='lake' AND DT = Article", editions = c("SCI"))# 11
pao_stream_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='stream' AND DT = Article", editions = c("SCI")) # 25
pao_river_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='river' AND DT = Article", editions = c("SCI")) # 3
pao_fw_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 13
pao_marine_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='marine' AND DT = Article", editions = c("SCI")) # 6
pao_ocean_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 2
pao_sw_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 7
pao_ag_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 1

# retrieve pub info
# pao_pubs_raw <- wos_retrieve(pao_result, count = 200)
pao_pubs_raw <- wos_retrieve_all(pao_result) %>% mutate(category = "all") # will pull all records
pao_wwtp_pubs_raw <- wos_retrieve_all(pao_wwtp_result) %>% mutate(category = "wwtp")
pao_soil_pubs_raw <- wos_retrieve_all(pao_soil_result) %>% mutate(category = "soil")
pao_sed_pubs_raw <- wos_retrieve_all(pao_sed_result) %>% mutate(category = "sediment")
pao_lake_pubs_raw <- wos_retrieve_all(pao_lake_result) %>% mutate(category = "lake")
pao_stream_pubs_raw <- wos_retrieve_all(pao_stream_result) %>% mutate(category = "stream")
pao_river_pubs_raw <- wos_retrieve_all(pao_river_result) %>% mutate(category = "river")
pao_marine_pubs_raw <- wos_retrieve_all(pao_marine_result) %>% mutate(category = "marine")
pao_ocean_pubs_raw <- wos_retrieve_all(pao_ocean_result) %>% mutate(category = "ocean")
pao_sw_pubs_raw <- wos_retrieve_all(pao_sw_result) %>% mutate(category = "sw")
pao_ag_pubs_raw <- wos_retrieve_all(pao_ag_result) %>% mutate(category = "ag")

# export raw data for future reading in
write_csv(x = pao_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_pubs_raw.csv"))
write_csv(x = pao_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_wwtp_pubs_raw.csv"))
write_csv(x = pao_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_soil_pubs_raw.csv"))
write_csv(x = pao_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_sed_pubs_raw.csv"))
write_csv(x = pao_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_lake_pubs_raw.csv"))
write_csv(x = pao_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_stream_pubs_raw.csv"))
write_csv(x = pao_river_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_river_pubs_raw.csv"))
write_csv(x = pao_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_marine_pubs_raw.csv"))
write_csv(x = pao_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_ocean_pubs_raw.csv"))
write_csv(x = pao_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_sw_pubs_raw.csv"))
write_csv(x = pao_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_ag_pubs_raw.csv"))

# bind rows
pao_all_searches_pubs_raw <- bind_rows(pao_pubs_raw, pao_wwtp_pubs_raw,
                                       pao_soil_pubs_raw, pao_sed_pubs_raw,
                                       pao_lake_pubs_raw, pao_stream_pubs_raw,
                                       pao_river_pubs_raw, pao_marine_pubs_raw,
                                       pao_ocean_pubs_raw, pao_sw_pubs_raw,
                                       pao_ag_pubs_raw)

# export full dataset
write_csv(x = pao_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "pao_all_searches_pubs_raw.csv"))


# ---- 6. ----



#


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
# TODO Ryan suggests to normalize by number of pubs in microbiology or some broader field
# TODO Theo asked if spikes were from funding cycle (3-years)?
  
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

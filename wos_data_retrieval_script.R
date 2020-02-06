# web of science meta-analysis

# ---- 1. load libraries ----
# install.packages("devtools")  # if required
# devtools::install_github("juba/rwos")
library(rwos)
library(tidyverse)
library(here)

# define paths 
# tabular_raw_data_path <- here("data", "tabular", "wos_raw_data")
tabular_raw_data_path <- "" # (use hardcoding for now)

# rwos docs
# https://github.com/juba/rwos

# options: "SCI", "IC", "ISTP", "ISSHP"
# USFS only authorized for "SCI"
# http://help.incites.clarivate.com/inCites2Live/dataAndSubscriptionNotificationsGroup/dataAndSubsNotice.html


# ---- 2. initiate wos session ----
# get session identifier
sid <- wos_authenticate()


# ---- 3. "microbiology" search ----

# "microbiology" search
microbio_result <- wos_search(sid, "TS='microbiology' AND DT = Article", editions = c("SCI"))
# 25270 results found


# retrieve pub info
microbio_pubs_raw <- wos_retrieve(microbio_result, count = 200)
# microbio_pubs_raw <- wos_retrieve_all(microbio_result) # will pull all records

# export raw data for future reading in
# write_csv(polyp_pubs_raw, )


# ---- 4. "polyphosphate" search ----
# "polyphosphate" search
# search for all articles
# polyp_result <- wos_search(sid, "TS='polyphosphate'", editions = c("SCI")) # articles and other docs
polyp_result <- wos_search(sid, "TS='polyphosphate' AND DT = Article", editions = c("SCI")) # only articles
# 9172 results found

# retrieve pub info
polyp_pubs_raw <- wos_retrieve(polyp_result, count = 200)
# polyp_pubs2 <- wos_retrieve_all(polyp_result) # will pull all records

# export raw data for future reading in
# write_csv()

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
  theme_bw()
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

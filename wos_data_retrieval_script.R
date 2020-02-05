# web of science analysis

# load libraries
# install.packages("devtools")  # if required
# devtools::install_github("juba/rwos")
library(rwos)
library(tidyverse)

# rwos docs
# https://github.com/juba/rwos

# options: "SCI", "IC", "ISTP", "ISSHP"
# USFS only authorized for "SCI"
# http://help.incites.clarivate.com/inCites2Live/dataAndSubscriptionNotificationsGroup/dataAndSubsNotice.html

# get session identifier
sid <- wos_authenticate()

# "polyphosphate" search
# search for all articles
# polyp_result <- wos_search(sid, "TS='polyphosphate'", editions = c("SCI")) # articles and other docs
polyp_result <- wos_search(sid, "TS='polyphosphate' AND DT = Article", editions = c("SCI")) # only articles
# 9172 results found

# retrieve pub info
polyp_pubs_raw <- wos_retrieve(polyp_result, count = 200)
# polyp_pubs2 <- wos_retrieve_all(polyp_result) # will pull all 9172 records

# wrangle
polyp_pubs <- polyp_pubs_raw %>%
  mutate(journal_name = str_to_title(journal),
         # TODO fix this: keywords_fix = str_replace_all(keywords, " ", ","))



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

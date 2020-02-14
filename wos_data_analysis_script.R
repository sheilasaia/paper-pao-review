# web of science data analysis

# ---- 1. load libraries ----
library(tidyverse)
library(here)
library(ggforce)

# define paths 
# tabular_raw_data_path <- here("data", "tabular", "wos_raw_data")
tabular_raw_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/raw_data/" # (use hardcoding for now)
# tabular_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/data/"

# ---- 2. load data ----

paper_counts_data_raw <- read_csv(paste0(tabular_raw_data_path, "wos_paper_counts_raw.csv"))



# ---- 3. calculate paper count fraction ----

# TODO maybe just show articles over time as fractions?

# wrangle data to divide by polyP and PAOs by microbiology keywords
paper_counts_data <- paper_counts_data_raw %>%
  pivot_wider(names_from = keyword, values_from = count) %>%
  mutate(polyp_perc = polyp/microbio * 100,
         pao_perc = pao/microbio * 100) %>%
  select(environment, category, polyp_perc, pao_perc) %>%
  pivot_longer(cols = c(polyp_perc, pao_perc), names_to = "keyword", values_to = "count_perc") %>%
  mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"),
         keyword_recode = recode_factor(keyword, "polyp_perc" = "polyP", "pao_perc" = "PAO"))

# ---- 3.1 plot paper count fraction ----

my_category_colors <- c("white", "darkgoldenrod2", "darkolivegreen3", "lightskyblue", "darkcyan", "darkorange")
ggplot(data = paper_counts_data) +
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


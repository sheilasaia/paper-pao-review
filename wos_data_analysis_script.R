# web of science data analysis

# ---- 1. load libraries ----
library(tidyverse)
library(here)
library(ggforce)
# library(gtable)
library(gridExtra)

# define paths 
# tabular_raw_data_path <- here("data", "tabular", "wos_raw_data")
# tabular_raw_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/raw_data/" # (use hardcoding for now)
# tabular_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/data/"
tabular_raw_data_path <- "/Users/sheila/Dropbox/aaaaa_transfers/full_submission_mar2020/raw_data/"


# ---- 2. load data ----
# overall paper counts data
paper_counts_data_raw <- read_csv(paste0(tabular_raw_data_path, "wos_paper_counts_raw.csv"))

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
  mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# wrangle phosphorus data
phos_pubs_data <- phos_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) %>%
  #   mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture")) # there's no "all" category yet...
# exclude "all" category for now (since can't get more than 100K entries from wos)

# wrangle microbio data
microbio_pubs_data <- microbio_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),
         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) %>%
  #   mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# wrangle polyp data
polyp_pubs_data <- polyp_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) %>%
  #   mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))

# wrangle pao data
pao_pubs_data <- pao_pubs_data_raw %>%
  mutate(year_fix = as.numeric(year),
         journal_fix = str_replace_all(str_to_title(journal), c(" Of " = " of ", " The " = " the ", "And" = "and", "&" = "and", " In " = " in ", " Et " = " et ")),         keywords_fix = str_to_lower(str_replace_all(keywords, " \\|\\ ", ",")),
         authors_fix = str_to_lower(str_replace_all(str_replace_all(str_replace_all(str_replace_all(authors, ", ", "_"), " \\|\\ ", ","), " ", "_"), "\\.", "")),
         journal_short = if_else(str_count(journal_fix, " ") >= 3, paste0(word(journal_fix, start = 1, end = 3), "..."), journal_fix)) %>%
  select(uid, title, journal_fix, journal_short, year_fix, keywords_fix, authors_fix, environment, category) %>%
  #   mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
  #          environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
  filter(category != "all") %>% # exclude "all" category for now (since can't get more than 100K entries from wos)
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"))
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

# only calculate fractions for specific environments
paper_counts_data_frac <- paper_counts_data %>%
  filter(category != "all") %>%
  mutate(total_collect = if_else(keyword == "phos", 183683,
                                 if_else(keyword == "microbio", 25359,
                                         if_else(keyword == "polyp", 9217, 796)))) %>%
  mutate(count_perc = round(count/total_collect * 100, digits = 1),
         count_perc_text = paste0(count_perc, "%"))


# ---- 4.2 plot overall pub counts ----
# define colors
# my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# phosphorus papers
p1 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "phos")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 1500, label = count_perc_text)) +
  xlab("") +
  ylab("Number of WOS Articles Returned") +
  ylim(0, 45000) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 45000, label = "(a) 'phosphorus'\n     (total collection = 183,683)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# microbiology papers
p2 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "microbio")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 40, label = count_perc_text)) +
  xlab("") +
  ylab("") +
  ylim(0, 1250) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 1250, label = "(b) 'microbiology'\n     (total collection = 25,359)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# polyp papers
p3 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "polyp")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 25, label = count_perc_text)) +
  xlab("Environment") +
  ylab("Number of WOS Articles Returned") +
  ylim(0, 650) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 650, label = "(c) 'polyphosphate'\n     (total collection = 9,217)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12), 
        legend.position = "none")

# pao papers
p4 <- ggplot(data = paper_counts_data_frac %>% filter(keyword == "pao")) +
  geom_col(aes(x = environment, y = count, fill = category), color = "black") +
  geom_text(aes(x = environment, y = count + 15, label = count_perc_text)) +
  xlab("Environment") +
  ylab("") +
  ylim(0, 450) +
  scale_fill_manual(values = my_category_colors) +
  annotate("text", x = 1, y = 450, label = "(d) 'polyphosphate accumulating organisms'\n     (total collection = 796)", size = 4, hjust = 0) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
grid.arrange(p1, p2, p3, p4, nrow = 2)


# ---- 5.1 calculate paper counts over time -----
# phosphorus pubs vs time
phos_pubs_time_data <- phos_pubs_data %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(search = "phosphorus")

# microbio pubs vs time
microbio_pubs_time_data <- microbio_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(search = "microbiology")

# polyp pubs vs time
polyp_pubs_time_data <- polyp_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(search = "polyphosphate")

# pao pubs vs time
pao_pubs_time_data <- pao_pubs_data %>%
  filter(category != "all") %>%
  group_by(category, year_fix) %>%
  count() %>%
  ungroup() %>%
  filter(year_fix >= 1990 & year_fix < 2020) %>%
  mutate(search = "PAOs")
  
# bind datasets
all_pubs_time_data <- bind_rows(phos_pubs_time_data, microbio_pubs_time_data, polyp_pubs_time_data, pao_pubs_time_data) %>%
  mutate(search = fct_relevel(as.character(search), "microbiology", "phosphorus", "polyphosphate", "PAOs"))


# ---- 5.2 plot paper counts over time -----
# search point shapes
my_search_shapes = c(21, 22, 23, 24)
# my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# wwtp results
p5 <- ggplot(data = all_pubs_time_data %>% filter(category == "wwtp")) +
  geom_line(aes(x = year_fix, y = n, linetype = search)) +
  geom_point(aes(x = year_fix, y = n, shape = search), size = 3, alpha = 0.80, fill = "lightgoldenrod", color = "black") +
  annotate("text", x = 1990, y = 800, label = "(a) 'wwtp'", size = 4, hjust = 0) +
  xlab("Year") +
  ylab("Number of WOS Articles Returned (between 1990-2019)") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12),
        legend.position = "none")

# ag results
p6 <- ggplot(data = all_pubs_time_data %>% filter(category == "agriculture")) +
  geom_line(aes(x = year_fix, y = n, linetype = search)) +
  geom_point(aes(x = year_fix, y = n, shape = search), size = 3, alpha = 0.80, fill = "sienna", color = "black") +
  annotate("text", x = 1990, y = 200, label = "(b) 'agriculture'", size = 4, hjust = 0) +
  xlab("Year") +
  ylab("") +
  scale_shape_manual(values = my_search_shapes) +
  # scale_color_manual(values = my_category_colors) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))

# plot together
# https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html
grid.arrange(p5, p6, nrow = 1)


# ---- 6.1 calculate journal-specific pub counts ----
# phos pubs per jounal (top journal)
phos_pubs_journal_data <- phos_pubs_data %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))

# microbio pubs per jounal (top journal)
microbio_pubs_journal_data <- microbio_pubs_data %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))

# polyp pubs per jounal (top journal)
polyp_pubs_journal_data <- polyp_pubs_data %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))


# pao pubs per jounal (top journal)
pao_pubs_journal_data <- pao_pubs_data %>%
  group_by(category, journal_fix) %>%
  count() %>%
  ungroup() %>%
  group_by(category) %>%
  mutate(pub_rank = dense_rank(desc(n))) %>%
  filter(pub_rank <= 5) %>%
  ungroup() %>%
  # mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))
  mutate(category = fct_relevel(category, "wwtp", "terrestrial", "freshwater", "marine", "agriculture"))


# ---- 6.2 plot journal-specific pub counts ----
# define colors
my_category_colors_all <- c("white", "lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")
my_category_colors <- c("lightgoldenrod", "darkolivegreen3", "lightskyblue", "darkcyan", "sienna")

# microbiology results
ggplot(data = microbio_pubs_journal_data) +
  geom_col(aes(x = journal_fix, y = n, fill = category), color = "black") +
  xlab("Journal") +
  ylab("Number of WOS Articles Returned") +
  scale_fill_manual(values = my_category_colors_all) +
  theme_classic() +
  theme(axis.title.x = element_text(size = 12),
        axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.text = element_text(size = 12))


# ---- 7.1 author counts ----
# phosphate
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
  mutate(author_rank = dense_rank(desc(n))) %>%
  filter(author_rank <= 2) %>%
  ungroup()

# andrew sharpley is only coming up 2 times, helen jarvie only 3
# maybe people don't really use phosphorus as a keyword...
# some papers have over lots of co-authors (e.g., "Atlas of modern dinoflagellate cyst distribution based on 2405 data points" had 42 authors!)

# paos
pao_author_data <- pao_pubs_data %>%
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
  mutate(author_rank = dense_rank(desc(n))) %>%
  filter(author_rank <= 1) %>%
  ungroup()
  

  
# ---- 8.1 overlapping journal articles ----

# count number of papers that overlap between searches
phos_pubs_overlap_summary <- phos_pubs_data %>%
  group_by(uid) %>%
  count(name = "n_overlaps") %>%
  ungroup()

# count number of overlapping papers
phos_pubs_overlap_count <- phos_pubs_overlap_summary %>%
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

# TODO have to figure out to how to get environment column to have list of all environments

# upset plot
install.packages("ggupset")
library(ggupset)
ggplot(data = phos_pubs_data %>% select(uid, environment), aes(x = environment)) +
  geom_bar() +
  scale_x_upset(n_intersections = 10)

data0 <- Titanic
data1 <- reshape2::melt(Titanic)
data2 <- gather_set_data(data1, 1:4)
ggplot(data2, aes(x, id = id, split = y, value = value)) +
  geom_parallel_sets(aes(fill = Sex), alpha = 0.3, axis.width = 0.1) +
  geom_parallel_sets_axes(axis.width = 0.1) +
  geom_parallel_sets_labels(colour = 'white')

blah0 <- tidy_movies 
blah1 <- blah0 %>%
  distinct(title, year, length, .keep_all=TRUE)
ggplot(data = blah1, aes(x=Genres)) +
  geom_bar() +
  scale_x_upset(n_intersections = 20)


# ---- TO DO LIST ----

# TODO make table for top 1
# TODO deal with/calculate overlapping papers...
# TODO Ryan suggested to normalize by number of pubs in microbiology or some broader field
# TODO Theo asked if spikes were from funding cycle (3-years)?


# ---- X.1 calculate paper count fraction ----
# wrangle data to divide by polyP and PAOs by microbiology keywords
paper_counts_perc_data <- paper_counts_data_raw %>%
  pivot_wider(names_from = keyword, values_from = count) %>%
  mutate(polyp_perc = polyp/microbio * 100,
         pao_perc = pao/microbio * 100) %>%
  select(environment, category, polyp_perc, pao_perc) %>%
  pivot_longer(cols = c(polyp_perc, pao_perc), names_to = "keyword", values_to = "count_perc") %>%
  mutate(category = fct_relevel(category, "all", "wwtp", "terrestrial", "freshwater", "marine", "agriculture"),
         environment = fct_relevel(environment, "all", "wwtp", "soil", "sediment", "lake", "stream", "river", "freshwater", "marine", "ocean", "saltwater", "agriculture"),
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
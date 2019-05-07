library(tidyverse)
library(lubridate)
library(zoo)

commits_by_date = read_csv("./data/daily_lang_commit_counts.csv") %>%
  rename(
    date = commit_date,
    n = count,
  ) %>%
  group_by(lang) %>%
  filter(!(abs(n - median(n)) > 5 * sd(n))) %>% # remove outliers by lang
  ungroup %>%
  group_by(date) %>%
  mutate(freq = n / sum(n)) %>%
  ungroup

all_languages = unique(commits_by_date$lang) %>% sort

top_20_languages = commits_by_date %>%
  group_by(lang) %>%
  summarise(commit_count = sum(n)) %>%
  arrange(desc(commit_count)) %>%
  filter(!is.na(lang)) %>%
  .$lang %>%
  head(20)

top_5_languages = head(top_20_languages, 5)

commits_with_dates = read_csv('data/commits_sample.csv') %>%
  mutate(date = as_date(as_datetime(seconds)))

commit_tallies = commits_with_dates %>%
  head(100) %>%
  group_by(date, author_name, email, repo) %>%
  tally %>%
  spread(repo, n, fill = 0, drop = T)

head(commit_tallies)

head(commit_tallies %>% filter("500tech/mimic" > 1))
  # %>%
  # spread(repo, n)

commit_tallies = commits_with_dates %>%
  head(10) %>%
  group_by(author_name, email, repo) %>%
  tally %>%
  spread(repo, n, fill = 0, drop = T) %>%
  ungroup

# commit_tallies$row.name = commit_tallies$row.name

# weighted adjacency matrix
bip = commit_tallies %>% select(-one_of("author_name"))

# rownames(bip) <-  c("Site 1", "Site 2", "Site 3", "Site 4", "Site 5", "6", "7", "8", "9", "10")
bip = column_to_rownames(bip, var = "email")

print(head(bip))

# # NETWORK GRAPH
# library(nycflights13)
# library(igraph)
# library(intergraph)
# library(sna)
# library(ggplot2)
# library(ggnetwork)
# library(plotly)
# library(htmlwidgets)

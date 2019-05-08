library(tidyverse)
library(lubridate)


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

repos_and_langs = read_csv("data/github_repos_and_langs.csv") %>%
  rename(repo = repo_name)
head(repos_and_langs)

commits_with_dates = read_csv('data/commits_sample.csv') %>%
  mutate(date = as_date(as_datetime(seconds))) %>%
  inner_join(repos_and_langs)

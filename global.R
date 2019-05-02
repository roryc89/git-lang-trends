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
  ungroup

all_languages = unique(commits_by_date$lang) %>% sort

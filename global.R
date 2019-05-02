library(tidyverse)
library(lubridate)
library(zoo)

# repos_and_langs = read_csv("./data/github_repos_and_langs.csv")
#
# commits = read_csv("./data/commits.csv") %>%
#   rename(repo_name = repo) %>%
#   mutate(
#     datetime = as_datetime(seconds),
#     date = as.Date(as_datetime(seconds), format="%y/%m/%d"),
#   ) %>%
#   full_join(repos_and_langs) %>%
#   filter(!is.na(lang)) %>%
#   filter(!is.na(email))
#
# sample(commits)
#
# all_languages = commits %>%
#   group_by(lang) %>%
#   summarise(n = n()) %>%
#   arrange(desc(n)) %>%
#   .$lang
#
# commits_by_date = commits %>%
#   group_by(date, lang) %>%
#   tally()

commits_by_date = read_csv("./data/daily_lang_commit_counts.csv") %>%
  rename(
    date = commit_date,
    n = count,
  ) %>%
  group_by(lang) %>%
  mutate(rolling_n = rollmean(n,30,mean,align='left',fill=NA)) %>%
  ungroup

all_languages = unique(commits_by_date$lang) %>% sort
  # group_by(date, lang) %>%
  # tally()
# all_languages
tail(commits_by_date)

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

top_25_languages = commits_by_date %>%
  group_by(lang) %>%
  summarise(commit_count = sum(n)) %>%
  arrange(desc(commit_count)) %>%
  filter(!is.na(lang)) %>%
  .$lang %>%
  head(25)

top_10_languages = head(top_25_languages, 10)

data_science_languages = c(
  "Python", "R", "Java", "SQL", "Julia", "Scala", "Matlab"
)

functional_languages = c(
  "Clojure", "OCaml", "Haskell", "Julia", "Scala", "Elixir", "Idris", "Elm", "PureScript"
)

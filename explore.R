library(tidyverse)

commits_2016 = read_csv('data/commits_2015_2016.csv')
commits_2017 = read_csv('data/commits_2016_2017.csv')
commits_2018 = read_csv('data/commits_2017_2018.csv')
commits_2019 = read_csv('data/commits_2018_2019.csv')

head(commits_2016)
head(commits_2017)
head(commits_2018)
head(commits_2019)

commits = rbind(
  commits_2016,
  commits_2017,
  commits_2018,
  commits_2019
)

write_csv(commits, 'data/commits.csv')
nrow(commits)

nrow(commits_sample)

commits_sample = commits[seq(1, nrow(commits), 100), ]

write_csv(commits_sample, 'data/commits_sample.csv')

unique(commits$repo)

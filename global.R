library(dplyr)
flights = read.csv(file = "./flights14.csv")

repos = read.csv(file = "./repos-langs-and-date.csv")
repos = repos[order(repos$language), ]


aggs = aggregate(repos$count, by=list(language=repos$language), FUN=sum)

top_languages = aggs[order(-aggs$x), ] %>%
  head(., n=25) %>%
  .$language %>%
  as.character

all_languages = unique(repos$language) %>%
  as.character %>%
  sort

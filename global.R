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
all_languages
top_4_languages = aggs[order(-aggs$x), ] %>%
  head(., n=4) %>%
  .$language %>%
  as.character


top_4_lang_repos = filter(repos, language %in% top_4_languages)

library("ggplotgui")

# You can call the function with and without passing a dataset

all_langs_stats = group_by(repos, created_at) %>%
  select(., -language) %>%
  summarise_all(funs(sum))


write.csv(top_4_lang_repos,file="top4.csv",row.names=TRUE,col.names=TRUE)

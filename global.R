library(dplyr)
library(lubridate)

flights = read.csv(file = "./flights14.csv")

repos = read.csv(file = "./repos-langs-and-date.csv")
head(repos)

day_sums = repos %>%
  group_by(created_at) %>%
  summarise(all_watchers = sum(watchers_sum), all_forks = sum(forks_sum))

# repos =
# rownames(day_sums) <- day_sums$created_at
repos = inner_join(repos, day_sums, by = "created_at") %>%
  mutate(
    fork_day_ratio = forks_sum/all_forks,
    watchers_day_ratio = watchers_sum/all_watchers,
    year = year(created_at),
    month = month(created_at)
  )

repos = repos[order(repos$language), ]

repos_by_month = repos %>%
  group_by(year, month, language) %>%
  summarise(
    # language = language,
    # year = year,
    # month = month,
    created_at = ymd(paste0(first(year), "-",
    first(month), "-01")),
    count = sum(count),
    fork_day_ratio = mean(fork_day_ratio),
    watchers_day_ratio = mean(watchers_day_ratio)
  )
repos_by_month

aggs = aggregate(repos$count, by=list(language=repos$language), FUN=sum)

top_languages = aggs[order(-aggs$x), ] %>%
  head(., n=25) %>%
  .$language %>%
  as.character
top_languages
all_languages = unique(repos$language) %>%
  as.character %>%
  sort

11195572
16896079
37754749

3349035
230171941
14295617

1498129

top_4_languages = aggs[order(-aggs$x), ] %>%
  head(., n=) %>%
  .$language %>%
  as.character

top_4_lang_repos = filter(repos, language %in% top_4_languages)


all_langs_stats = group_by(repos, created_at) %>%
  select(., -language) %>%
  summarise_all(funs(sum))


write.csv(top_4_lang_repos,file="top4.csv",r
  ow.names=TRUE,col.names=TRUE)

library(tidyverse)

fn <- here::here(sprintf("data-raw/anime-titles-%s.dat.gz", Sys.Date()))

# download file if only it doesn't exist.
# Devs don't want this file to be downlaoded more than once per day:
# https://wiki.anidb.net/API#Anime_Titles
if(!file.exists(fn)) {
  download.file("http://anidb.net/api/anime-titles.dat.gz",
                destfile = fn)
}
animetitles <- readr::read_delim(fn, delim = "|", skip = 3,
                                  col_names = c("aid", "type", "language", "title"),
                                  col_types = "iicc") %>%
  mutate(type = fct_recode(as.character(type),
                           "primary" = "1",
                           "synonym" = "2",
                           "short-title" = "3",
                           "official" = "4")) %>%
  arrange(aid) %>%
  as.data.frame()

# There are some problematic titles:
# aid=11040 -> Haikyu!! Movie 1 - Ende und Anfang | Haikyu!! Movie 2 - Gewinner und Verlierer
# aid=8895 -> Shin Evangelion Gekijouban:||
# aid=8895 -> シン・エヴァンゲリオン劇場版:||
# aid=2643 -> 赛亚人灭绝计划 ~地球篇|宇宙篇~

primarytitles <- animetitles %>%
  filter(type %in% "primary") %>%
  filter(!language %in% c("en", "my", "zh-Hant")) %>%
  mutate(language = fct_recode(language,
                               "x-jat" = "ja",
                               "x-zht" = "zh"),
         origin = fct_recode(language,
                             "JP" = "x-jat",
                             "KR" = "x-zht",
                             "CN" = "x-kot")) %>%
  select(-language, -type) %>%
  arrange(aid) %>%
  rename(title_primary = title)

englishtitles <- animetitles %>%
  filter(type %in% "official") %>%
  filter(language == "en",
         aid %in% primarytitles$aid) %>%
  arrange(aid) %>%
  select(-type, -language) %>%
  rename(title_en = title)

get_original_titles <- function(language, origin) {
  animetitles %>%
    filter(aid %in% primarytitles$aid[primarytitles$origin==.env$origin],
           type == "official",
           language == .env$language) %>%
    select(-type, -language) %>%
    rename(title_original = title)
}

jatitles <- get_original_titles("ja", "JP")
kotitles <- get_original_titles("ko", "KR")
zhtitles <- get_original_titles("zh", "CN")
originaltitles <- rbind(jatitles, kotitles, zhtitles)

officialtitles <- primarytitles %>%
  left_join(englishtitles, by = "aid") %>%
  left_join(originaltitles, by = "aid") %>%
  select(aid, origin, title_primary, title_en, title_original)

#primarytitles %>%
#  pivot_wider(aid, names_from = language, values_from = title) %>%
#  View()

attr(officialtitles, "date") <- Sys.Date()
usethis::use_data(officialtitles, overwrite = TRUE)
attr(animetitles, "date") <- Sys.Date()
usethis::use_data(animetitles, overwrite = TRUE)

## abstracts. parse table and remove stop words.

source('data-raw/common.R')
library(tidytext)

path <- 'data-raw//ABSTRACTS'

col_types <- cols_only(
  APPLICATION_ID = col_integer(),
  ABSTRACT_TEXT = col_character()
)

abstracts.tbl <- load_tbl(path, col_types) %>%
  filter(!is.na(abstract.text))

data(stop_words)
abstract_tokens <-
  abstracts.tbl %>%
  # head(100) %>% # testing
  unnest_tokens(word, abstract.text) %>%
  filter(word != "unreadable" & !str_detect(word, "[:digit:]+")) %>%
  anti_join(stop_words) %>%
  count(application.id, word) %>%
  arrange(application.id, desc(n))

use_data(abstract_tokens, compress = 'xz')

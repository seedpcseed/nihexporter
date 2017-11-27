## abstracts

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
  unnest_tokens(word, abstract.text) %>%
  anti_join(stop_words)

use_data(abstract_tokens, compress = 'xz')

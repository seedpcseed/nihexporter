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

# split into two tables for efficient storage:
# one containing words, another containg word counts
abstract_words <-
  abstract_tokens %>%
  select(word) %>%
  unique() %>%
  arrange(word) %>%
  mutate(word.id = row_number())

abstract_word_counts <-
  abstract_tokens %>%
  left_join(abstract_words) %>%
  select(-word) %>%
  unique()

use_data(abstract_words, compress = 'xz')
use_data(abstract_word_counts, compress = 'xz')

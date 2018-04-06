library(rvest)
library(magrittr)
library(tibble)
library(stringr)

url = "https://www.rottentomatoes.com/"

page = read_html(url)

fix_gross = function(x) {
  str_replace(x,"M$","") %>%
    str_replace("^\\$","") %>%
    as.double() %>%
    {. * 1e6}
}

fix_tmeter = function(x) {
  str_replace(x,"%$","") %>%
    as.double() %>%
    {./100}
}

fix_icon = function(x) {
  str_replace(x, "icon tiny ", "") %>%
    str_replace("_", " ") %>% 
    tools::toTitleCase()
}

data_frame(
  url = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_attr("href") %>% paste0(url, .),
  title = page %>% html_nodes("#Top-Box-Office .middle_col a") %>% html_text(),
  weekend = page %>% html_nodes("#Top-Box-Office .right a") %>% html_text() %>% str_trim() %>% fix_gross(),
  tmeter = page %>% html_nodes("#Top-Box-Office .tMeterScore") %>% html_text() %>% fix_tmeter(),
  rating = page %>% html_nodes("#Top-Box-Office .tiny") %>% html_attr("class") %>% fix_icon()
)

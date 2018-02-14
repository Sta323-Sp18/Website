library(stringr)
library(lubridate)
library(magrittr)

files = list.files(path = "./", pattern="^2017")

rx = str_match(files, "(2017-[0-9]{2}-[0-9]{2})(-.*)")

old_files = rx[,1]
old_dates = ymd(rx[,2])

new_start = "2017-08-28" %>% ymd(tz="America/New_York")
old_start = old_dates[1]

new_dates = new_start + (old_dates - old_start)
new_files = paste0(round_date(new_dates,"day"), rx[,3])


for(i in seq_along(new_files))
{
  file.rename(old_files[i], new_files[i])  
}

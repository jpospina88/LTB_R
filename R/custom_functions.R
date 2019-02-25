letter2point <- function(data, gradeCol) {
  names(letter.code)[match(data[[gradeCol]], letter.code)]
}

#### Get Deographics ####

demographics_pct <- function(data, factors){
  data %>% 
    count(!!!factors) %>% 
    mutate(total = sum(n, na.rm = F),
           pct = round(n/total*100, 1)) %>% 
    kable_format
}

# Example
# demogs <- quos(t1ses, ses, ses_working_lowmiddle, t1ses_workinglowermiddleclass)
# d0 %>% 
#   # filter(!is.na(race_nointl_wPI_USETHIS)) %>% 
#   demographics_pct(demogs)

#### Format Tables with Kable ####
kable_format <- . %>% 
  kable(format = "html") %>% 
  kable_styling(bootstrap_options = c("hover", "responsive"), font_size = 12, full_width = F)

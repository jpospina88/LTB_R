library(tidyverse)
library(googlesheets)

# Notes about reviewing the pre- post-intervention measure. If good, this means that the participant has pre- and post-intervention data
notes <-
  tribble(
    ~Participant, ~grades_notes,                                                                                                      
    "P01",        "No grades data",
    "P02",        "No post-intv data",
    "P03",        "Good",
    "P04",        "Good",
    "P05",        "Good",
    "P08",        "Good",
    "P09",        "Good",
    "P10",        "Good",
    "P14",        "No post-intv data - the date of the intervention was 44 days (over 30 days) past",
    "P16",        "No post-intv data",
    "P17",        "No post-intv data - the date of the intervention was 37 days (over 30 days) past",
    "P18",        "Good",
    "P20",        "Good",
    "P21",        "Good",
    "P22",        "Has pre-intv data but only has one value in post-intv data",
    "P23",        "No post-intv data",
    "P27",        "No post-intv data",
    "P28",        "No post-intv data",
    "P29",        "Good",
    "P30",        "No post-intv data - the date of the intervention was 80 days (over 30 days) past",
    "P31",        "Good",
    "P32",        "No pre-intv data",
    "P33",        "No intervention at all",
    "P34",        "Good",
    "P36",        "No post-intv data - the date of the intervention was 102 days (over 30 days) past",
    "P38",        "Good, but no intervention until 183 after fall quarter start, 29 days after spring quarter start",
    "P39",        "Good",
    "P40",        "No post-intv data - the date of the intervention was 115 days (over 30 days) past",
    "P44",        "No intervention until 190 after fall quarter start, 36 days after spring quarter start, No post-intv data",
    "P46",        "Good, but no intervention until 186 after fall quarter start, 32 days after spring quarter start",
    "P50",        "No post-intv data, No intervention until 206 after fall quarter start, 52 days after spring quarter start",
    "P54",        "No post-intv data, No intervention until 253 after fall quarter start, 99 days after spring quarter start ",
    "P56",        "Good, but no intervention until 235 after fall quarter start, 81 days after spring quarter start",
    "P58",        "No post-intv data, No intervention until 241 after fall quarter start, 87 days after spring quarter start",
    "P59",        "Good, but no intervention until 242 after fall quarter start, 88 days after spring quarter start",
    "P60",        "Good, but no intervention until 256 after fall quarter start, 102 days after spring quarter start",
    "P62",        "No post-intv data, No intervention until 263 after fall quarter start, 109 days after spring quarter start",
    "P63",        "Good, but no intervention until 262 after fall quarter start, 108 days after spring quarter start",
    "S01",        "No intervention",
    "S02",        "No intervention",
    "S03",        "No intervention",
    "S07",        "No intervention"
  )

# ltb_notes_ss <- gs_new("LTB Notes Academic Data", ws_title = "Master", input = notes, verbose = FALSE)

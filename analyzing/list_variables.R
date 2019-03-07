vars_cont <- 
  quos(
    # Pre-Measures
    s0.grit_c5,
    s0.personality_c5,
    s0.school_c2,
    s0.police_c2,
    s1.belong_c4,
    s1.belong_wonder,
    s0.classanx_c2,
    s1.schoolfair_c2,
    s1.safety_c4,
    s2.school_exper,
    s2.belong_c4,
    s2.belong_diff
  ) 

tribble_dv <- tribble(
  ~dv,                                       ~dv_name,                                              ~scale,            ~limit,          ~position,            ~subheader,                                       ~decimal,
  #-----------------------------------------|------------------------------------------------------|-----------------|----------------|----------------------|-------------------------------------------------|---------
  # Institutional data
  "s0.grit_c5",                              "Grit",                                                seq(1, 5, 1),      c(1, 5),         1.5,                  "(Pre-Measure; 5 Items)",                                  3,
  "s0.personality_c5",                       "I.T. of Personality",                                 seq(1, 7, 1),      c(1, 7),         1.5,                  "(Pre-Measure; Higher = More Fixed; 5 Items)",             3,
  "s0.school_c2",                            "Succeed at School",                                   seq(1, 7, 1),      c(1, 7),         1.5,                  "(Pre-Measure; 2 Items)",                                  3,
  "s0.police_c2",                            "Police Concerns & Expectations Because of J.D.",      seq(1, 6, 1),      c(1, 6),         1.5,                  "(Pre-Measure; 2 Items)",                                  3,
  "s1.belong_c4",                            "Belonging at School",                                 seq(1, 6, 1),      c(1, 6),         1.5,                  "(Post-Intervention; 4 Items)",                            3,
  "s1.belong_wonder",                        "Belonging Uncertainty",                               seq(1, 5, 1),      c(1, 5),         1.5,                  "(Post-Intervention; 1 Item; Higher = Less Uncertainty)", 3,
  "s0.classanx_c2",                          "Class Anxiety",                                       seq(1, 7, 1),      c(1, 7),         1.5,                  "(Post-Intervention; 2 Items)",                            3,
  "s1.schoolfair_c2",                        "Fairness at School",                                  seq(1, 7, 1),      c(1, 7),         1.5,                  "(Post-Intervention; 2 Items)",                            3,
  "s1.safety_c4",                            "Feeling of Safety",                                   seq(1, 4, 1),      c(1, 4),         1.5,                  "(Post-Intervention; 4 Items)",                            3,
  "s2.school_exper",                         "Experience in School",                                seq(1, 5, 1),      c(1, 5),         1.5,                  "(Follow-Up; 1 Item; Higher = Worse)",                     3,
  "s2.belong_c4",                            "Belonging at School",                                 seq(1, 6, 1),      c(1, 6),         1.5,                  "(Follow-Up; 4 Items)",                                    3,
  's2.belong_diff',                          "Difference of Belonging at School",                   seq(-2, 2, 0.5),   c(-2, 2),        -1.5,                    "(More Negative = Higher Belonging Gap)",           2
)  

tribble_cond <- data.frame(matrix(c("cond"), nrow = nrow(tribble_dv)))

names_cond <- c("cond")
colnames(tribble_cond) <- names_cond

tribble_cont <- bind_cols(tribble_dv, tribble_cond)

rm(tribble_dv, tribble_cond)

# groups for plots
color_treat <- scale_fill_manual(name = "", 
                                 values = c("control" = "salmon", 
                                            "intv" = "#steelblue2",
                                            "letter" = "springgreen4"))

legend_treat <- scale_color_manual(name = "", 
                                   values = c("control" = "salmon", 
                                              "intv" = "#steelblue2",
                                              "letter" = "springgreen4"))

positions_treat <- c("control", "intv", "letter")

labels_treat <- scale_x_discrete(labels = c('Control','Intervention', 'Intervention +\nLetter'), limits = positions_treat)

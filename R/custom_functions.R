#### Convert letter grades to numbers ####
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

#### Compute scale reliability ####
alphatize_2 <- function(data, vector){
  data %>% 
    select(!!!vector) %>% # note that variables in ... must be pre-quoted using quos() function
    na.omit() %>% 
    psych::alpha(check.keys=TRUE) 
}

#### Get quoted names of variables ####
get_names <- function(data, keyword){
  data %>% 
    select(contains(keyword)) %>% 
    names
}

#### Factor Analysis ####
factor_analysis <- function(data, vector, nfactors){
  fact <- data %>% select(!!!vector)
  
  corr_table <- round(cor(fact, use = "pairwise.complete.obs"), digits = 3) # you need to determine how NAs should be treated. SPSS uses deleting NAs pairwise as a default, so R should do the same in order to compare the results
  
  scree_plot <- scree(corr_table, factors = TRUE, pc = FALSE, main = "Scree plot", hline = NULL, add = FALSE); scree_plot # pc: principal components, pc is used in Confirmatory Factor Analysis (CFA), instead of Exploratory Factor Analysis (EFA)
  # if the Eigen value is above the cutoff in the scree_plot, then you have a factor!
  
  # Begin Factor Analysis
  # dim(fact); str(fact)
  
  # when reviewing the output of factanal, the Factor of each item should be > .6 to consider these items as part of the composite that we want to compute.
  factanal(na.omit(fact), 
           factors = nfactors, # how many factors to calculate
           rotation = "varimax") # "varimax" uncorrelate the items by computing an orthogonal vector with all the items
}

# Example
# factor_analysis(d0, var_purp, 2)

#### Overall descriptive statistics ####

describe_vars <- . %>% 
  describe %>% 
  as.data.frame() %>% 
  rownames_to_column(var = "dv_name") %>% 
  mutate_at(vars(-dv_name), funs(round(., digits = 2))) %>% 
  kable_format

# Example
# ltb %>% 
#   select(!!!vars_cont) %>% 
#   describe_vars

#### Round Summary Tables to Any Decimal ####
round_table <- function(data, excluded_vars, decimal){
  data %>% 
    mutate_at(vars(-c(!!!excluded_vars)), 
              funs(round(., digits = decimal))) 
}

#### Format Correlation Tables ####
# Simple custom function to format the correlation table to show in the report
corr_kable <- . %>% 
  as.data.frame() %>% 
  filter(Variable != " " | `1` != " ") %>% 
  kable_format()

#### Get APA Correlation Table ####

corr_table <- function(data, vars){
  corr_table <- 
    data %>% 
    select(!!!vars) %>% 
    apa.cor.table()
  
  corr_table$table.body %>% 
    corr_kable
}

#### Standardize variables ####
standardize_list_vars <- function(data, vector){
  # this function requires a vector of the variables that you want to standardize AND an ID vector with your participants' ID to merge them back with the full dataset
  fact <- data %>% select(!!!vector)
  
  fact_z <- fact %>% mutate_all(funs(scale(.)))
  
  colnames(fact_z) <- paste(colnames(fact_z), "z", sep = "_")
  
  fact_z_id <- bind_cols(id, fact_z)
}

# Standardize list of variables
# id <- ltb %>% select(Participant)
# vars_std <- standardize_list_vars(ltb, quos(vars))

#### Move variables in the dataset ####
moveme <- function(data, tomove, where = "last", ba = NULL) {
  temp <- setdiff(names(data), tomove)
  x <- switch(
    where,
    first = data[c(tomove, temp)],
    last = data[c(temp, tomove)],
    before = {
      if (is.null(ba)) stop("must specify ba column")
      if (length(ba) > 1) stop("ba must be a single character string")
      data[append(temp, values = tomove, after = (match(ba, temp)-1))]
    },
    after = {
      if (is.null(ba)) stop("must specify ba column")
      if (length(ba) > 1) stop("ba must be a single character string")
      data[append(temp, values = tomove, after = (match(ba, temp)))]
    })
  x
}

# df <- moveme(df, c("b", "c"))
# df <- moveme(df, c("b", "c"), "first")
# df <- moveme(df, c("b", "c"), "before", "e") # will move b and c before e.
# df <- moveme(df, c("b", "c"), "after", "e")

#### Raincluod plots custom functions ####
# Violin Plots
geom_flat_violin <-
  function(mapping = NULL,
           data = NULL,
           stat = "ydensity",
           position = "dodge",
           trim = TRUE,
           scale = "area",
           show.legend = NA,
           inherit.aes = TRUE,
           ...) {
    ggplot2::layer(
      data = data,
      mapping = mapping,
      stat = stat,
      geom = GeomFlatViolin,
      position = position,
      show.legend = show.legend,
      inherit.aes = inherit.aes,
      params = list(trim = trim,
                    scale = scale,
                    ...)
    )
  }

GeomFlatViolin <-
  ggproto(
    "GeomFlatViolin",
    Geom,
    setup_data = function(data, params) {
      data$width <- data$width %||%
        params$width %||% (resolution(data$x, FALSE) * 0.9)
      
      # ymin, ymax, xmin, and xmax define the bounding rectangle for each group
      data %>%
        dplyr::group_by(.data = ., group) %>%
        dplyr::mutate(
          .data = .,
          ymin = min(y),
          ymax = max(y),
          xmin = x,
          xmax = x + width / 2
        )
    },
    
    draw_group = function(data, panel_scales, coord)
    {
      # Find the points for the line to go all the way around
      data <- base::transform(data,
                              xminv = x,
                              xmaxv = x + violinwidth * (xmax - x))
      
      # Make sure it's sorted properly to draw the outline
      newdata <-
        base::rbind(
          dplyr::arrange(.data = base::transform(data, x = xminv), y),
          dplyr::arrange(.data = base::transform(data, x = xmaxv), -y)
        )
      
      # Close the polygon: set first and last point the same
      # Needed for coord_polar and such
      newdata <- rbind(newdata, newdata[1,])
      
      ggplot2:::ggname("geom_flat_violin",
                       GeomPolygon$draw_panel(newdata, panel_scales, coord))
    },
    
    draw_key = draw_key_polygon,
    
    default_aes = ggplot2::aes(
      weight = 1,
      colour = "grey20",
      fill = "white",
      size = 0.5,
      alpha = NA,
      linetype = "solid"
    ),
    
    required_aes = c("x", "y")
  )


raincloud_point <- function(data, factor, mn) {
  ftr <- enquo(factor)
  mn <- enquo(mn)
  
  geom_point(data = data, aes_(x = ftr, y = mn), 
             position = position_nudge(x = 0.3), size = 1.5)
}

raincloud_theme <- 
  theme(text = element_text(size = 10),
        axis.title.x = element_text(size = 16),
        axis.title.y = element_text(size = 16),
        axis.text = element_text(size = 10),
        axis.text.x = element_text(angle = 0, vjust = 0),
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 16),
        legend.position = "right",
        plot.title = element_text(lineheight = .8, face = "bold", size = 16),
        panel.border = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_blank(),
        axis.line.x = element_line(colour = 'black', size = 0.5, linetype = 'solid'),
        axis.line.y = element_line(colour = 'black', size = 0.5, linetype = 'solid'),
        strip.text = element_text(color = "Black"), strip.background = element_blank())

raincloud_violin <- 
  geom_flat_violin(position = position_nudge(x = .2, y = 0), alpha = .8)

raincloud_boxplot <-
  geom_boxplot(width = .1, guides = FALSE, outlier.shape = NA, alpha = 0.5)

raincloud_guides <- 
  guides(fill = FALSE, color = FALSE)

raincloud_theme_light <- 
  theme_light()

stat_summary_se <- 
  stat_summary(fun.data = mean_se, geom = "errorbar", width = .1, position = position_nudge(x = .3, y = 0))

#### Bar plots settings ####

# These elements are not going to change from plot to plot, so I added them here so we don't have to copy paste unnecesary code
pd1 <- position_dodge()
pd2 <- position_dodge(0.1)
pd3 <- position_dodge(width = 0.9)
black1 <- element_text(color = "White")
black2 <- element_rect(fill = "black", colour = "Black", size = NULL, linetype = NULL, color = "Black", inherit.blank = FALSE)

theme1 <- theme_light()
# theme1 <- theme_classic()
guides_no <- guides(fill = FALSE)
pd4 <- position_stack(vjust = 1.1)
letter2point <- function(data, gradeCol) {
  names(letter.code)[match(data[[gradeCol]], letter.code)]
}

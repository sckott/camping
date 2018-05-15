clean_categories <- function(x) {
  # restroom
  x$restroom2 <- tolower(x$Restroom)
  x$restroom2 <- stringi::stri_replace_all(x$restroom2, "", regex = "toilets?")
  x$restroom2 <- stringi::stri_trim_both(x$restroom2)
  x$restroom2 <- stringi::stri_replace_all(x$restroom2, "flush", regex = "flushing")
  
  # restroom
  x$water2 <- tolower(x$Water)
  x$water2 <- stringi::stri_replace_all(x$water2, "no", regex = "no.+")
  
  # return
  return(x)
}

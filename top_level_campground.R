options(stringsAsFactors = FALSE)

# main site
top_level_campground <- function(url, ...) {
  cli <- crul::HttpClient$new(url, opts = list(...))
  res <- cli$get()
  res$raise_for_status()
  html1 <- xml2::read_html(res$parse("UTF-8"))
  # xml2::write_html(html1, "stuff.html")
  cgrounds <- xml_find_all(html1, '//a[contains(text(), "Campground")]')
  nms <- unname(vapply(xml_text(cgrounds), function(z) {
    if (grepl(":", z)) strsplit(z, ":")[[1]][[2]] else z
  }, ""))
  cgrounds_hrefs <- xml_attr(cgrounds, "href")
  url_pref <- "https://www.fs.usda.gov"
  cgrounds_urls <- unname(vapply(cgrounds_hrefs, function(x) {
    if (grepl("https?", x)) x else paste0(url_pref, x)
  }, ""))
  
  # each_campground_safe <- plyr::try_default(each_campground, error_list)
  all_campgrounds <- unname(Map(each_campground, cgrounds_urls, nms))
  
  # remove those that don't have data
  all_campgrounds <- Filter(function(x) NROW(x$dat) > 0, all_campgrounds)
  
  # combine them
  ddf <- tbl_df(bind_rows(lapply(all_campgrounds, function(z) {
    z$no_sites <- unique(z$no_sites)
    if (length(z$no_sites) > 1) z$no_sites <- z$no_sites[1]
    df <- data.frame(str_trim(z$campground), 
                     as.numeric(z$latitude), 
                     as.numeric(z$longitude), 
                     as.numeric(z$elevation), 
                     as.numeric(str_extract(z$no_sites, "[0-9]+")) %||% NA_real_,
                     stringsAsFactors = FALSE)
    z$dat$X1 <- gsub(":\\s?", "", z$dat$X1)
    dat <- t(data.frame(stats::setNames(z$dat$X2, z$dat$X1)))
    rownames(dat) <- NULL
    df <- stats::setNames(df, c("name", "lat", "lon", "elev", "no_sites"))
    df <- cbind(df, dat)
    if (!is.null(df$Restroom)) {
      df$Restroom <- gsub("\\(.+", "", df$Restroom)  
    }
    df
  })))
  # readr::write_csv(all_campgrounds_df, "all_campgrounds_df.csv")
  
  return(ddf)
}

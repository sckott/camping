# for each campground site
# each_campground(cgrounds_urls[1], nms[1])
each_campground <- function(url, name, ...) {
  cli <- crul::HttpClient$new(url, opts = list(...))
  res2 <- cli$get()
  res2$raise_for_status()
  html2 <- xml2::read_html(res2$parse("UTF-8"))
  
  table_glance <- xml_find_all(html2, '//table[contains(@summary, "Glance")]')
  table_glance_df <- rvest::html_table(table_glance)[[1]]
  
  no_site <- xml_text(xml_find_all(html2, '//table//tr//text()[contains(., "single site(")]'))
  
  lat <- str_extract(xml_text(xml_find_first(html2, '//div[contains(text(), "Latitude")]/following-sibling::div')), "-?[0-9]+\\.[0-9]+")
  lon <- str_extract(xml_text(xml_find_first(html2, '//div[contains(text(), "Longitude")]/following-sibling::div')), "-?[0-9]+\\.[0-9]+")
  elev <- str_extract(xml_text(xml_find_first(html2, '//div[contains(text(), "Elevation")]/following-sibling::div')), "[0-9]+")
  
  list(
    campground = name, 
    dat = table_glance_df, 
    no_sites = no_site,
    latitude = lat, 
    longitude = lon, 
    elevation = elev
  )
}
`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x

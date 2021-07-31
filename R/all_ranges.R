all_ranges <- function(chroms=c(seq(1,100),"X","Y"),
                       min_pos=0,
                       max_pos=1000000000000000000
                       ){ 
  
    ranges <- paste0(# chromosomes (some species have crazy #s of chroms)
      chroms,":", 
      # start positions 
      min_pos,":", 
      # end positions (max # of 0s before getting response error)
      formatC(max_pos, 
              format = "f", digits = 0)) 
    return(ranges)
}
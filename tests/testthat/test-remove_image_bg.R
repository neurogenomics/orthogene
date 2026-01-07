test_that("remove_image_bg works", {
  
    
    path <- paste0("https://images.phylopic.org/images/",
                   "2de1c95c-7e1f-429b-9c08-17f0a27d176f/vector.svg")
    img_res <- orthogene:::remove_image_bg(path=path)
    
    testthat::expect_true(methods::is(img_res$image,"magick-image"))
    
})

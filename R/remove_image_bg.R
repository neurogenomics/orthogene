#' Remove image background
#' 
#' Import and image and remove the background using \pkg{magick}.
#' @inheritParams magick::image_read_svg
#' @inheritParams magick::image_transparent
#' @returns Named list containing the modified image itself and 
#' the saved path of the modified image.
#' 
#' @keywords internal
#' @source 
#' \code{
#' path <- paste0("https://images.phylopic.org/images/",
#' "2de1c95c-7e1f-429b-9c08-17f0a27d176f/vector.svg")
#' img_res <- remove_image_bg(path=path)
#' }
remove_image_bg <- function(path,
                            color = 'white',
                            fuzz = 0,
                            save_path=file.path(
                                tempdir(),"phylopic_processed",
                                paste0(basename(dirname(path)),".png"))
                            ){
    requireNamespace("magick")
    
    if(grepl("\\.svg$",path)){
        img <- magick::image_read_svg(path = path)    
    } else {
        img <- magick::image_read(path = path)
    }
    img <- magick::image_transparent(image = img,
                                     color = color,
                                     fuzz = fuzz) 
    dir.create(dirname(save_path), showWarnings = FALSE, recursive = TRUE)
    magick::image_write(image = img, 
                        path = save_path)  
    return(list(image=img,
                save_path=save_path))
}
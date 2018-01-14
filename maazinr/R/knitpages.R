#!/usr/local/bin/Rscript --vanilla

# compiles all .Rmd files in _R directory into .md files in blog directory,
# if the input file is older than the output file.

# run ./knitpages.R to update all knitr files that need to be updated.
# run this script from your base content directory

library(knitr)

#' Knit Post
#'
#' This function converts .Rmd files in a directory to .md files in another directory
#' @param input input .Rmd
#' @param outfile output .md
#' @param figsfolder where figures will be
#' @param cachefolder idk
#' @param base.url the base directory
#' @keywords knit
#' @export

KnitPost <- function(input, outfile, figsfolder, cachefolder, base.url = "/") {
    opts_knit$set(base.url = base.url)
    fig.path <- paste0(figsfolder, sub(".Rmd$", "", basename(input)), "/")
    cache.path <- file.path(cachefolder, sub(".Rmd$", "", basename(input)), "/")

    opts_chunk$set(fig.path = fig.path, cache.path = cache.path, fig.cap = "center")
    render_markdown()
    knit(input, outfile, envir = parent.frame())
}

knit_folder <- function(infolder, outfolder = "posts/", figsfolder = "static/", cachefolder =  "_caches", force = F) {
    for (infile in list.files(infolder, pattern = "*.Rmd", full.names = TRUE, recursive = TRUE)) {

        print(infile)
        outfile = paste0(outfolder, "/", sub(".Rmd$", ".md", basename(infile)))
        print(outfile)

        # knit only if the input file is the last one modified
        if (!file.exists(outfile) | file.info(infile)$mtime > file.info(outfile)$mtime) {
            KnitPost(infile, outfile, figsfolder, cachefolder)
        }
    }
}

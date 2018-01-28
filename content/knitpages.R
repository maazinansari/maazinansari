# original author: Michael Toth 
# https://github.com/michaeltoth/michaeltoth/blob/master/knitpages.R

# compiles all .Rmd files in _R directory into .md files in blog directory,
# if the input file is older than the output file.

# run ./knitpages.R to update all knitr files that need to be updated.
# run this script from your base content directory

library(knitr)
KnitPost <- function(input, outfile, figsfolder, base.url = "/") {
    opts_knit$set(base.url = base.url)
    fig.path <- paste0(figsfolder, sub(".Rmd$", "", basename(input)), "/")
    
    opts_chunk$set(fig.path = fig.path, fig.cap = "center")
    render_markdown()
    knit(input, outfile, envir = parent.frame())
}

knit_folder <- function(infolder, outfolder = "posts/", figsfolder = "static/", force = F) {
    for (infile in list.files(infolder, pattern = "*.Rmd", full.names = TRUE, recursive = TRUE)) {
        
        print(infile)
        outfile = paste0(outfolder, "/", sub(".Rmd$", ".md", basename(infile)))
        print(outfile)
        
        # knit only if the input file is the last one modified
        if (!file.exists(outfile) | file.info(infile)$mtime > file.info(outfile)$mtime) {
            KnitPost(infile, outfile, figsfolder)
        }
    }
}

knit_folder("R/")

browseURL("https://github.com/yihui/xaringan/wiki/Export-Slides-to-PDF")
browseURL("https://github.com/astefanutti/decktape")
browseURL("https://github.com/astefanutti/decktape/releases/tag/v1.0.0")


files = dir("pres/", recursive = TRUE, pattern = ".html$")
files = files[3]
in_file = normalizePath(file.path("pres", files[1]))
out_file = gsub(".html", ".pdf", in_file)
# doing it without Chrome
cmd = paste("decktape", in_file, out_file, "--no-sandbox")
system(cmd)


# # webshot does not work, I suspect because I have not installed Chrome
# for (i in files) {
#   in_file = i
#   out_file = gsub(".html", ".pdf", in_file)
#   webshot(files, "~/uni/test.pdf")
# }




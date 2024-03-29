## Had to debug a git-related issue that was crashing Rstudio
#debug(sandpaper:::init_source_path)
#debug(gert::git_init)
#debug(gert:::R_git_repository_init)
#gert::git_init(".")

# Test
rmarkdown::pandoc_version()
tmp <- tempfile()
sandpaper::no_package_cache()

sandpaper::create_lesson(tmp, open = FALSE)
sandpaper::build_lesson(tmp, preview = FALSE, quiet = TRUE)
fs::dir_tree(tmp, recurse = 1)


sandpaper::serve()
sandpaper::build_lesson()

# create episode
sandpaper::create_episode("introduction")

# Check & build & serve
sandpaper::check_lesson()
sandpaper::build_lesson(".", preview = TRUE, quiet = TRUE)
#sandpaper::serve()


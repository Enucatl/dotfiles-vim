options(repos = c(CRAN = "http://cran.uk.r-project.org/"))

setHook(packageEvent("grDevices", "onLoad"),
        function(...) grDevices::X11.options(type='cairo'))
options(device='x11')

setHook(packageEvent("ggplot2", "attach"),
    function(...) {
        require(grid)
        require(extrafont)
        suppressMessages(loadfonts())
        theme_set(theme_bw(base_size=24) + theme(
            legend.key.size=unit(2, 'lines'),
            text=element_text(family='CM Roman')
            ))
        })

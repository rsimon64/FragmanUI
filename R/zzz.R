.onAttach <- function(libname, pkgname) {

  txt <- paste(
    "Esto es una versión beta del paquete 'FragmanUI':\n
    Versión ",
    utils::packageVersion("FragmanUI"), "\n\n")
  txt <- paste(txt,
               "Favor registrar fallas o sugerencias usando:
               https://github.com/rsimon64/FragmanUI/issues\n")
  packageStartupMessage(txt)

  utils::data(liz600)
}

.onLoad <- function(libname, pkgname) {

}

.onAttach <- function(libname, pkgname) {

  txt <- paste(
    "Esto es una versi\u00F3n beta del paquete 'FragmanUI':\n
    Versi\u00F3n ",
    utils::packageVersion("FragmanUI"), "\n\n")
  txt <- paste(txt,
               "Favor registrar fallas o sugerencias usando:
               https://github.com/rsimon64/FragmanUI/issues\n")
  packageStartupMessage(txt)

}

.onLoad <- function(libname, pkgname) {

}

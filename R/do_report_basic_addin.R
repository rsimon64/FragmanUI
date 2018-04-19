do_report_basic_addin <- function() {
  is.defined <- function(sym) class(try(sym, TRUE))!='try-error'

  advice_folder <- function(){
    message("Favor definir un directorio con datos: folder <- choose.dir()")
    rstudioapi::sendToConsole(paste0("folder <- choose.dir()"), execute = FALSE)
  }

  if(is.defined(folder)) {
    message("No existe el objeto 'folder' en la sesión de R.")
    advice_folder()
    return()
  }

  if(!dir.exists(folder)) {
    message("No existe el objeto 'folder' indicado.")
    advice_folder()
  }

  FragmanUI:::do_report_basic(folder)

}

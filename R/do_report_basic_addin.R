do_report_basic_addin <- function() {
  is.defined <- function(sym) class(try(sym, TRUE))!='try-error'

  advice_folder <- function(diagnosis){
    message(diagnosis)
    message("Favor definir un directorio con datos: folder <- choose.dir()")
    rstudioapi::sendToConsole(paste0("folder <- choose.dir()"), execute = FALSE)
  }

  # if(is.defined("folder")) {
  #   advice_folder("No existe el objeto 'folder' en la sesión de R.")
  #   return()
  # }
  #
  #
  # if(!dir.exists(folder)) {
  #   advice_folder("No existe el objeto 'folder' indicado.")
  #   return()
  # }


  # TODO check on presence of correct file(s)

  FragmanUI:::do_report_basic(folder)

}

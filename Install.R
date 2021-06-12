# install RTools manually https://cran.r-project.org/bin/windows/Rtools/
# install Java, https://java.com/de/download/

# if the program wants to do some updates, do the updates

#if you get some problems during the instalation with fansi, clear the session and restart the Session
#In R Studio: go in the menu to Session/ClearWorkspace and then go Session/Restart 



remotes::install_github("marlonecobos/kuenm")

remotes::install_github("mrmaxent/maxnet")

remotes::install_github("Model-R/modleR", build = TRUE)

# rdt (analysiert R während es läuft und erstellt das Protokoll)
# rdt analyse R during the run and build a protocoll
devtools::install_github("End-to-end-provenance/rdt")
# rdt2repr (provenance parser, convert the protocall to a ontologie)
devtools::install_github("mmondelli/rdt2repr")

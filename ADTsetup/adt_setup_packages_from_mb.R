options(repos=unique(c(mvb="https://markbravington.github.com/Rmvb-repo",getOption('repos'))))

install.packages(pkg='mvbutils')
install.packages(pkg='debug')
install.packages(pkg='atease')
install.packages(pkg='offarray')

install.packages("//akc0ss-n086/NMML_USERS/paul.conn/Downloads/newadt_1.03.zip",repos=NULL,type="win.binary")
#Mark emailed this to me

library(newadt)
new.adt("c:/users/paul.conn/git/CKMR","Bearded","Bd")

#now upen in MS Visual Studio 2015 Community edition (note 2017 version not compatible!)

new.adt("c:/users/paul.conn/git/CKMR","Bearded2","Bd",src.templates=file.path(dirname(Sys.which('adt.exe')),'../templates/ckmr'))
new.adt("c:/users/paul.conn/git/CKMR","spatial","sp",src.templates='c:/users/paul.conn/git/ckmr/template/PO_HSP/')

library("debug")
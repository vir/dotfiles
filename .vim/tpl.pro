PROJECT                 = someproject
TEMPLATE                = app
CONFIG                  = warn_on qt thread debug
OBJECTS_DIR             = obj
MOC_DIR                 = moc
HEADERS                 = proj1.h \
                          proj2.h 
SOURCES                 = proj1.cpp \
                          proj2.cpp 

unix:HEADERS           += unix.h
unix:SOURCES           += unix.cpp
unix:DEFINES            = COMPILING_ON_UNIX
 
win32:HEADERS          += win.h
win32:SOURCES          += win.cpp

DESTDIR                 = dest
TARGET                  = proj

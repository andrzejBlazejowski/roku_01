#########################################################################
# Simple makefile for packaging VideoCanvas test channel
#
# SOURCEDIR is set below to this repo's channel root (source/) so you can run
# make from the project root or from source/ — zipping always uses that folder.
#
# From repo root:
#   make -f makefile/makefile run
#
# Or from channel root:
#   make -C source -f ../makefile/makefile run
#
# Important Notes:
# To use the "install" and "remove" targets to install your
# application directly from the shell, you must do the following:
#
# 1) Make sure that you have the curl command line executable in your path
# 2) Set the variable ROKU_DEV_TARGET in your environment to the IP
#    address of your Roku box. (e.g. export ROKU_DEV_TARGET=192.168.1.1).
#    Set this variable in your shell startup (e.g. .bashrc)
##########################################################################
APPNAME = hello_world
VERSION = 1.0

ZIP_EXCLUDE= -x \*.pkg -x storeassets\* -x keys\* -x \*/.\*

# Absolute channel root (manifest lives here); keeps `run: remove install` safe with -j.
MAKEFILE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SOURCEDIR := $(abspath $(MAKEFILE_DIR)/../source)

# Resolve app.mk next to this file.
include $(dir $(lastword $(MAKEFILE_LIST)))app.mk

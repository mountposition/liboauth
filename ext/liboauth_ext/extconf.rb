# encoding: utf-8
require 'mkmf'

have_library("ssl")

create_makefile('liboauth_ext');

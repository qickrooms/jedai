################################################################
# Copyright (c) 2007 Allurent, Inc.
# http://code.google.com/p/antennae/
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
################################################################

This is a set of self-guiding progressive samples developed to
illustrate the use of Ant with Flex, based on some simple "toy"
projects.  It does not assume any existing knowledge of Ant, but
does assume the user has access to Ant reference materials.

Contents:

build-user.properties
    Properties file that should be adjusted to a particular developer's
    environment.
    
build.xml
    Master build file for building the app2/ and multi/ projects.

app1/
    Example project to get a feel for what an Ant build file looks like
    and how dependicies work.

app2/
    Simple Flex application project with a range of progressively more
    complex and more cleanly structured build approaches in numbered
    files buildN.xml. See comments in individual files.

multi/
    Complex Flex project including two library projects and an
    application, with dependencies and a master build file.

    build.xml
        master build file for 'multi' project: builds library1/, library2/
        and app/.

    library1/
    library2/
        two library projects, one dependent on the other

    app/
        an application project dependent on both libraries
        including application server staging and deployment targets

    .project
        Flex Builder Eclipse plugin project definition


# A virtual machine for developing and testing Canvas

## Introduction

This project automates the setup of a development environment for
[Canvas](https://github.com/instructure/canvas-lms). This will build a
development box that includes all of the dependencies outlined in the
[Canvas Quickstart
Guide](https://github.com/instructure/canvas-lms/wiki/Quick-Start).
Please see that guide if you want more details on what's included in the
build.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

## How To Build The Virtual Machine

To build the virtual machine, first start with:

    host $ git clone https://github.com/HatemAlSum/canvas-lms-dev-box.git
    host $ cd canvas-lms-dev-box
    host $ git submodule init
    host $ git submodule update
    host $ git clone https://github.com/instructure/canvas-lms.git
    host $ vagrant up

Once this finishes you will have a fully configured development environment ready and the development server is running. 

You can access it from you browser locally at http://localhost:3000

## Things to note

Vagrant mounts the root directory of this repository as `/vagrant` in the virtual machine. So you can make edits in your local machine and test or run the server in the virtual machine.

## Virtual Machine Management

When done just log out with `^D` and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please see the [Vagrant Documentation](http://vagrantup.com/v1/docs/index.html) for more information.

# Special thanks

This development environment was based on the [rails-dev-box](https://github.com/rails/rails-dev-box) project.

# Refrences
Detailed instructions for installation and configuration of Canvas
[Quick Start](https://github.com/instructure/canvas-lms/wiki/Quick-Start)

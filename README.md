# `gajdaw-symfony` Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)
6. [How do I test the module?](#how-do-i-test-the-module)

## Overview

This module installs all the software required by Symfony Standard.

There are two independend versions supposed to work on two platforms:

- Ubuntu 12.04 - version stored in branch 1.0
- Ubuntu 14.04 - version stored in branch 2.0


## Setup

To install the module run:

    sudo puppet install module gajdaw-symfony

## Usage

You can use the module running:

    sudo puppet apply -e 'include symfony'

## Limitations

The module was tested on:

* Ubuntu
  - 14.04 (trusty) (Vagrant box: ubuntu/trusty32)
  - 12.04 (precise) (Vagrant box: ubuntu/precise32)

Known problems:

- Version 0.1.7 uses `puppetlabs/apache` module.
This module is not compatible with `ppa:ondrej/php5`
on Ubuntu 12.04. Thus you cannot use v0.1.7 on Travis.

## Development

For development instructions visit
[Puppet Modules Factory](https://github.com/puppet-by-examples/puppet-modules-factory)

## How do I test the module?

I test the module for all supported platforms:

* Ubuntu 12.04 - precise - ubuntu/precise32 Vagrant box
* Ubuntu 14.04 - trusty - ubuntu/trusty32 Vagrant box

The procedure (for each platform):

    in Puppet Modules Factory repo
    set platform in Vagrantfile
    vagrant up
    update puppet if necessary
    sudo puppet apply -e 'include symfony'
    run behat/phpspec tests for the applications in sample/ directory


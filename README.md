# `symfony` Puppet Module

#### Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)

## Overview

This module installs all the software required by Symfony Standard.

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

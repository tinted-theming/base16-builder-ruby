# base16-builder-ruby

This is a base16 builder written in Ruby as defined by the [base16 builder
guidelines](https://github.com/tinted-theming/home/blob/cc34890294402b9052b528e107f5b6b5ae15fdff/builder.md)
version 0.9.0

## Requirements

* Ruby 2.3.0+ (You can use [rbenv](https://github.com/rbenv/rbenv) or
  [rvm](https://rvm.io/) to acquire a specific Ruby version)
* [Bundler](http://bundler.io/)

## Installation

If you have all the requirements listed above, `cd` to the directory where you
cloned this repository to then run `bundle install`. If everything succeeds you
should be able to use it as described below.

## Usage

```sh
./builder update
```
Clones or pulls all sources, schemes, and templates repositories.

```sh
./builder
```

Builds all templates and saves them in `/templates/<dir>` where `<dir>` is defined by
the template's configuration. If the necessary directories don't exist, it will
call `./builder update`

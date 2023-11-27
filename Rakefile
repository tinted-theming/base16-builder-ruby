# frozen_string_literal: true

require "rake/clean"

CLEAN.include("out")
CLOBBER.include("schemes", "sources", "templates")

require "bundler/gem_tasks"
require "standard/rake"

task default: :standard

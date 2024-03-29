#!/usr/bin/env ruby
require "thor"
require "parallel"

Dir["src/*.rb"].sort.each { |file| require_relative file }

PROCESS_COUNT = 6

class Builder < Thor
  package_name "base16-builder-ruby"

  no_commands do
    def required_dirs_exist?
      Dir.exist?("sources") && Dir.exist?("schemes") &&
        Dir.exist?("templates")
    end
  end
  desc "update", "Re-acquires all sources, schemes, and templates"

  def update
    schemes_repo = Base16Repository.schemes_repo
    templates_repo = Base16Repository.templates_repo

    schemes_repo.update
    templates_repo.update

    schemes_list = YAML.load_file("sources/schemes/list.yaml")
    templates_list = YAML.load_file("sources/templates/list.yaml")

    Parallel.each(schemes_list, in_processes: PROCESS_COUNT) do |k, v|
      # These repos now 404 on GitHub, maybe they were taken private?
      next if v.include? "aramisgithub"
      repo = Base16Repository.new(path: "schemes", name: k, url: v)
      repo.update
    end

    Parallel.each(templates_list, in_processes: PROCESS_COUNT) do |k, v|
      # textadept has moved their config file for some reason
      next if v.include? "textadept"
      repo = Base16Repository.new(path: "templates", name: k, url: v)
      repo.update
    end
  end

  desc "build", "Builds all templates for all schemes into ./outputs/"

  def build
    invoke :update unless required_dirs_exist?

    schemes = Scheme.load_schemes
    templates = Template.load_templates

    Parallel.each(schemes, in_processes: PROCESS_COUNT) do |s|
      templates.each do |t|
        t.render(scheme: s)
      end
    end
  end

  default_task :build
end

Builder.start(ARGV)

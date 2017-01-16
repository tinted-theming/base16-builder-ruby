#!/usr/bin/env ruby
require "thor"

Dir["src/*.rb"].each { |file| require_relative file }

class Builder < Thor
  package_name "base16-builder-ruby"

  no_commands do
    def required_dirs_exist?
      return Dir.exists?("sources") && Dir.exists?("schemes") &&
             Dir.exists?("templates")
    end
  end
  desc "update", "Re-acquires all sources, schemes, and templates"
  def update
    schemes_repo = Base16Repository.schemes_repo
    templates_repo = Base16Repository.templates_repo

    schemes_repo.update
    templates_repo.update

    schemes_list = YAML.load(File.read("sources/schemes/list.yaml"))
    templates_list = YAML.load(File.read("sources/templates/list.yaml"))

    schemes_list.each do |k, v|
      repo = Base16Repository.new(path: "schemes", name: k, url: v)
      repo.update
    end

    templates_list.each do |k, v|
      repo = Base16Repository.new(path: "templates", name: k, url: v)
      repo.update
    end
  end

  desc "build", "Builds all templates for all schemes into ./outputs/"
  def build
    schemes_repo = Base16Repository.schemes_repo
    templates_repo = Base16Repository.schemes_repo

    invoke :update unless required_dirs_exist?

    schemes = Scheme.load_schemes
    templates = Template.load_templates

    schemes.each do |s|
      templates.each do |t|
        t.render(scheme: s)
      end
    end
  end

  default_task :build
end

Builder.start(ARGV)

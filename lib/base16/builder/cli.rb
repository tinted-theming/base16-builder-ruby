# frozen_string_literal: true

require "parallel"
require "psych"
require "thor"

require_relative "repository"
require_relative "scheme"
require_relative "template"

module Base16
  module Builder
    class Cli < Thor
      PROCESS_COUNT = 6

      no_commands do
        def required_dirs_exist?
          Dir.exist?("sources") && Dir.exist?("schemes") &&
            Dir.exist?("templates")
        end
      end

      desc "update", "Re-acquires all sources, schemes, and templates"
      def update
        schemes_repo = Base16::Builder::Repository.schemes_repo
        templates_repo = Base16::Builder::Repository.templates_repo

        schemes_repo.update
        templates_repo.update

        schemes_list = Psych.safe_load_file("sources/schemes/list.yaml")
        templates_list = Psych.safe_load_file("sources/templates/list.yaml")

        Parallel.each(schemes_list, in_processes: PROCESS_COUNT) do |k, v|
          repo = Base16::Builder::Repository.new(path: "schemes", name: k, url: v)
          repo.update
        end

        Parallel.each(templates_list, in_processes: PROCESS_COUNT) do |k, v|
          # textadept has moved their config file for some reason
          next if v.include? "textadept"
          repo = Base16::Builder::Repository.new(path: "templates", name: k, url: v)
          repo.update
        end
      end

      desc "build", "Builds all templates for all schemes into ./outputs/"
      def build
        invoke :update unless required_dirs_exist?

        schemes = Scheme.all
        templates = Template.all

        Parallel.each(templates, in_processes: PROCESS_COUNT) do |t|
          t.mkdir_p

          schemes.each do |s|
            t.render(scheme: s)
          end
        end
      end

      default_task :build
    end
  end
end

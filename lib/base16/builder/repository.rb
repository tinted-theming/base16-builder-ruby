require "git"
require "safe_yaml/load"

module Base16
  module Builder
    class Repository
      @@sources_filename = "sources.yaml"
      @@sources_dir = "sources"

      attr_accessor :repo_path

      def self.repo_from_sources_yaml(key:)
        yaml = SafeYAML.load(File.read(@@sources_filename))
        url = yaml[key]

        return nil unless url

        new(
          path: @@sources_dir,
          name: key,
          url: url
        )
      end

      def self.schemes_repo
        repo_from_sources_yaml(key: "schemes")
      end

      def self.templates_repo
        repo_from_sources_yaml(key: "templates")
      end

      def initialize(path:, name:, url:)
        @path = path
        @name = name
        @url = url

        @repo_path = "#{@path}/#{@name}"
      end

      def update
        if exist?
          puts "Pulling #{@repo_path}..."
          repo = Git.open(@repo_path)
          repo.pull
        else
          clone
        end
      end

      def clone
        puts "Cloning #{@repo_path}..."
        Git.clone(@url, @name, path: @path, depth: 1)
      end

      def exist?
        Dir.exist?(@repo_path)
      end

      def is_scheme_list_repo?
        @repo_path == "sources/schemes"
      end

      def is_template_list_repo?
        @repo_path == "sources/templates"
      end

      def scheme_repo_urls
        return nil unless exist? && is_scheme_list_repo?
        SafeYAML.load(File.read("#{@repo_path}/list.yaml"))
      end

      def template_repo_urls
        return nil unless exist? && is_template_list_repo?
        SafeYAML.load(File.read("#{@repo_path}/list.yaml"))
      end
    end
  end
end

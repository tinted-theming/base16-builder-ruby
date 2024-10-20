require "slugify"

module Base16
  module Builder
    class Scheme
      attr_reader :name
      attr_reader :slug
      attr_reader :author
      attr_reader :bases

      class << self
        def all
          @all ||= Dir["schemes/*/*.yaml"].map { |file_path| load(file_path) }
        end

        def load(path)
          filename = File.basename(path, ".yaml")

          new(filename.slugify, Psych.safe_load_file(path))
        end
      end

      def initialize(slug, yaml)
        @author = yaml["author"]
        @name = yaml["scheme"]
        @slug = slug
        @bases = {}

        BASES.each do |b|
          @bases[b] = yaml[b]
        end
      end

      private

      BASES = %w[00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F].map { |suffix| "base#{suffix}" }.freeze
    end
  end
end

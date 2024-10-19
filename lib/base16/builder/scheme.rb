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
          @all ||= Dir["schemes/*/*.yaml"].map { |file_path| Scheme.new(file_path: file_path) }
        end
      end

      def initialize(file_path:)
        yaml = Psych.safe_load_file(file_path)
        filename = File.basename(file_path, ".yaml")

        @author = yaml["author"]
        @name = yaml["scheme"]
        @slug = filename.slugify
        @bases = {}

        bases = %w[00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F]

        bases.each do |b|
          key = "base#{b}"
          @bases[key] = yaml[key]
        end
      end
    end
  end
end

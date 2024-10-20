require "chroma"
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

      def to_context
        @to_context ||= begin
          data = {
            "scheme-name" => name,
            "scheme-author" => author,
            "scheme-slug" => slug
          }

          bases.each do |base_key, base_color|
            data["#{base_key}-hex"] = base_color

            data["#{base_key}-hex-r"] = base_color[0, 2]
            data["#{base_key}-hex-g"] = base_color[2, 2]
            data["#{base_key}-hex-b"] = base_color[4, 2]

            # Turn hex color into an array of [r, g, b]
            rgb = base_color.paint.to_rgb.scan(/\d+/)

            data["#{base_key}-rgb-r"] = rgb[0]
            data["#{base_key}-rgb-g"] = rgb[1]
            data["#{base_key}-rgb-b"] = rgb[2]

            data["#{base_key}-dec-r"] = rgb[0].to_i / 255.0
            data["#{base_key}-dec-g"] = rgb[1].to_i / 255.0
            data["#{base_key}-dec-b"] = rgb[2].to_i / 255.0
          end

          data
        end
      end

      private

      BASES = %w[00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F].map { |suffix| "base#{suffix}" }.freeze
    end
  end
end

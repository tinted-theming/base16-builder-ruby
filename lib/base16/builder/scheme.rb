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
            "scheme-name": name,
            "scheme-author": author,
            "scheme-slug": slug
          }

          bases.each do |base_key, base_color|
            data[:"#{base_key}-hex"] = base_color

            r = base_color[0, 2]
            g = base_color[2, 2]
            b = base_color[4, 2]

            data[:"#{base_key}-hex-r"] = r
            data[:"#{base_key}-hex-g"] = g
            data[:"#{base_key}-hex-b"] = b

            r = r.to_i(16)
            g = g.to_i(16)
            b = b.to_i(16)

            data[:"#{base_key}-rgb-r"] = r.to_s
            data[:"#{base_key}-rgb-g"] = g.to_s
            data[:"#{base_key}-rgb-b"] = b.to_s

            data[:"#{base_key}-dec-r"] = (r / 255.0).to_s
            data[:"#{base_key}-dec-g"] = (g / 255.0).to_s
            data[:"#{base_key}-dec-b"] = (b / 255.0).to_s
          end

          data
        end
      end

      private

      BASES = %w[00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F].map { |suffix| "base#{suffix}" }.freeze
    end
  end
end

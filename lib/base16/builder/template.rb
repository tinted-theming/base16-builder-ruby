require "mustache"
require "chroma"

module Base16
  module Builder
    class Template
      class << self
        def all
          @all ||= Dir["templates/**/templates"].map do |template_dir|
            config_file = File.join(template_dir, "config.yaml")
            Template.new(template_dir: template_dir, config_file: config_file)
          end
        end
      end

      def initialize(template_dir:, config_file:)
        @template_dir = template_dir

        @mustaches = Psych.safe_load_file(config_file).map do |key, template_file_config|
          mustache = Mustache.new
          mustache.template_file = "#{@template_dir}/#{key}.mustache"
          mustache.render

          [
            mustache,
            template_file_config
          ]
        end
      end

      def render(scheme:)
        @mustaches.each do |mustache, template_file_config|
          template_data = build_template_data(scheme: scheme)

          rendered_template = mustache.render(template_data)

          rendered_filename = "base16-#{scheme.slug}#{template_file_config["extension"]}"
          rendered_dir = "out/#{template_file_config["output"]}"

          FileUtils.mkdir_p(rendered_dir) unless Dir.exist?(rendered_dir)

          puts "building #{rendered_dir}/#{rendered_filename}"
          File.write("#{rendered_dir}/#{rendered_filename}", rendered_template)
        end
      end

      private

      def build_template_data(scheme:)
        data = {
          "scheme-name" => scheme.name,
          "scheme-author" => scheme.author,
          "scheme-slug" => scheme.slug
        }

        scheme.bases.each do |base_key, base_color|
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
  end
end

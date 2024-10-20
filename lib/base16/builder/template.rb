require "mustache"

module Base16
  module Builder
    class Template
      class << self
        def all
          @all ||= Dir["templates/**/templates"].map { |dir| from(dir) }
        end

        def from(template_dir)
          template_configs = Psych.safe_load_file(File.join(template_dir, "config.yaml"))

          new(template_dir, template_configs)
        end
      end

      def initialize(template_dir, template_configs)
        @template_dir = template_dir

        @mustaches = template_configs.map do |key, template_file_config|
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
          rendered_template = mustache.render(scheme.to_context)

          rendered_filename = "base16-#{scheme.slug}#{template_file_config["extension"]}"
          rendered_dir = "out/#{template_file_config["output"]}"

          FileUtils.mkdir_p(rendered_dir) unless Dir.exist?(rendered_dir)

          puts "building #{rendered_dir}/#{rendered_filename}"
          File.write("#{rendered_dir}/#{rendered_filename}", rendered_template)
        end
      end
    end
  end
end

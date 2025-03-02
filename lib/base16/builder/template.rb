require "mustache"

module Base16
  module Builder
    class Template
      class << self
        def all
          @all ||= Dir["templates/**/templates"].flat_map { |dir| from_config_in(dir) }
        end

        def from_config_in(template_dir)
          template_configs = Psych.safe_load_file(File.join(template_dir, "config.yaml"))

          template_configs.map do |key, template_config|
            new(template_dir, key, template_config)
          end
        end
      end

      def initialize(template_dir, key, template_config)
        @mustache = Mustache.new
        @mustache.template_file = "#{template_dir}/#{key}.mustache"
        @mustache.render

        @extension = template_config["extension"]
        @output = template_config["output"]

        @rendered_dir = "out/#{@output}"
      end

      def mkdir_p
        return if Dir.exist?(@rendered_dir)

        require "fileutils"
        FileUtils.mkdir_p(@rendered_dir)
      end

      def render(scheme:)
        rendered_template = @mustache.render(scheme.to_context)

        File.write("#{@rendered_dir}/base16-#{scheme.slug}#{@extension}", rendered_template)
      end
    end
  end
end

require "git"
require "yaml"

# If repository `name` exists at `path`, pull from it, otherwise clone it there
def clone_or_update(path:, name:, url:)
  repo_path = "#{path}/#{name}"

  if Dir.exists?(repo_path)
    repo = Git.open(repo_path)
    repo.pull
  else
    Git.clone(url, name, path: path)
  end
end

# 1. Parse YAML File
yaml = YAML.load(File.read("sources.yaml"))
schemes_url = yaml["schemes"]
templates_url = yaml["templates"]

sources_dir = "sources"

update = true

# TODO: Only update repos if they don't exist or if the update command is passed in
if update
  # 2. Clone repositories defined in parsed file to sources folder or pull if they exist
  clone_or_update(path: sources_dir, name: "schemes", url: schemes_url)
  clone_or_update(path: sources_dir, name: "templates", url: templates_url)

  # 3. Clone repositories defined in list.yaml to /schemes and /templates
  schemes = YAML.load(File.read("sources/schemes/list.yaml"))
  templates = YAML.load(File.read("sources/templates/list.yaml"))

  schemes.each do |k, v|
    clone_or_update(path: "schemes", name: k, url: v)
  end

  templates.each do |k, v|
    clone_or_update(path: "templates", name: k, url: v)
  end
end


# 4. TODO: Clear out any old output

# Iterate through each scheme
Dir["schemes/**/*.yaml"].each do |scheme_file|

  # Iterate through each template directory
  Dir["templates/**/templates/"].each do |template_dir|
    config_file = File.join(template_dir, "config.yaml")
    config = YAML.load(File.read(config_file))

    # Iterate through each mustache template for this template dir
    Dir["#{template_dir}/*.mustache"].each do |template_file|
      # ap template_file
    end
  end
end
require "git"
require "yaml"

# If repository `name` exists at `path`, pull from it, otherwise clone it there
def clone_or_update(path:, name:, url:)
  repo_path = "#{path}/#{name}"

  ap "clone_or_update(path: #{path}, name: #{name}, url: #{url})"
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


# 3. TODO: Clear out any old output
# 4. TODO: Iterate through each scheme
  # 5. TODO: Iterate through each template for each scheme
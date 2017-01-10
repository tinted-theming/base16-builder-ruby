require "git"
require "yaml"

# 1. Parse YAML File
yaml = YAML.load(File.read("sources.yaml"))
schemes_url = yaml["schemes"]
templates_url = yaml["templates"]

schemes_repo_path = "./sources/schemes"
templates_repo_path = "./sources/templates"

# 2. Clone repositories defined in parsed file to sources folder or pull if they exist

if Dir.exists?(schemes_repo_path)
  schemes_repo = Git.open(schemes_repo_path)
  schemes_repo.pull
else
  Git.clone(schemes_url, "schemes", path: "./sources")
end

if Dir.exists?(templates_repo_path)
  templates_repo = Git.open(templates_repo_path)
  templates_repo.pull
else
  Git.clone(templates_url, "templates", path: "./sources")
end


# 3. TODO: Clear out any old output
# 4. TODO: Iterate through each scheme
  # 5. TODO: Iterate through each template for each scheme
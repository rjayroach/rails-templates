require_relative 'app'
def source_paths; Array(super) + [Pathname.new(template_dir), "#{Pathname.new(template_dir)}/roles"] end

gem 'therubyracer', platforms: :ruby

name = 'microservice'
yml_file = "#{template_dir}/app.yml"
if File.exists?(yml_file)
  yml = YAML.load_file(yml_file)
  if yml[name]
    app.whitelist = yml[name]['whitelist'] if yml[name]['whitelist']
    app.blacklist = yml[name]['blacklist'] if yml[name]['blacklist']
  end
end

# Set default whitelist and blacklist if none provided
app.whitelist ||= %w(config defaults git)
app.blacklist ||= %w(trailblazer)

apply('common.rb')

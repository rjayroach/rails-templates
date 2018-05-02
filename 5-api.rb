require_relative 'app'
def source_paths; Array(super) + [Pathname.new(template_dir), "#{Pathname.new(template_dir)}/roles"] end

gem 'therubyracer', platforms: :ruby

app.whitelist = %w(config defaults git)
app.blacklist = %w(trailblazer)

apply('common.rb')

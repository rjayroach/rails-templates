require_relative 'app'
# require 'pry'
def source_paths; Array(super) + [Pathname.new(template_dir), "#{Pathname.new(template_dir)}/roles"] end

# Move to an example yaml
gem 'therubyracer', platforms: :ruby

# Set default whitelist and blacklist if none provided
app.whitelist = %w(defaults git) if app.whitelist.empty?
app.blacklist = %w(trailblazer) if app.blacklist.empty?

# wrap git :init with #inside b/c otherwise when a plugin is create pwd is dummy_path
inside('.') { git :init }

apply('common.rb')

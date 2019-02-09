require_relative 'app'
# require 'pry'
def source_paths; Array(super) + [Pathname.new(template_dir), "#{Pathname.new(template_dir)}/roles"] end

# binding.pry

# Set default whitelist and blacklist if none provided
app.whitelist = %w(defaults git) if app.whitelist.empty?
app.blacklist = %w(trailblazer) if app.blacklist.empty?

apply('common.rb')

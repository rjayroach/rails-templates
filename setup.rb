# TODO: Implement https://github.com/brigade/overcommit
require 'pry'
require_relative 'prepd'

# See: https://www.sitepoint.com/rails-application-templates-real-world/
def template_dir; @template_dir ||= File.expand_path(File.dirname(__FILE__)) end

def app
  @app ||= Prepd::Application.new(self, template_dir)
end

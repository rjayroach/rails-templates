# require 'pry'
module Custom
  class Application
    attr_reader :parent_dir, :app_dir, :application_name, :controllers_path, :is_plugin, :template_path
    attr_accessor :selected, :whitelist, :blacklist

    def method_missing(method_name, *arguments)
      if method_name[-1] == '?'
        applied.include?(method_name[0..-2]) || applied.include?(method_name[0..-2].gsub('_', '-'))
      else
        super
      end
    end

    def plugin?
      self.is_plugin
    end

    def initialize(rails_generator, template_path)
      @template_path = template_path
      @is_plugin =  rails_generator.class.name.eql? 'Rails::Generators::PluginGenerator'
      @parent_dir = Pathname.new(Dir.pwd).parent.to_s
      @app_dir = is_plugin ? dummy_path : '.'

      # NOTE: If the template is invoked with 'rails new <name>' then @app_name will be the value of <name>
      # However, if the template is invoked with 'rails plugin new <name>' then @app_name will be nil
      @application_name = is_plugin ? rails_generator.instance_variable_get('@app_name')
        : rails_generator.instance_variable_get('@app_name')

      @controllers_path = is_plugin ? "app/controllers/#{@name}" : 'app/controllers'

      @selected = []
    end

    def roles
      (Dir.chdir("#{template_path}/roles") { Dir.glob('*') } - %w(application plugin)).sort
    end

    def available
      roles - whitelist - blacklist
    end

    def applied
      (selected + whitelist).sort
    end

    def ask
      available.each do |component|
        selected << component if thor.yes?("Add #{component.capitalize}?")
      end
    end

    def thor
      @thor ||= Thor.new
    end
  end
end

# See: https://www.sitepoint.com/rails-application-templates-real-world/
def template_dir; @template_dir ||= File.expand_path(File.dirname(__FILE__)) end

def app
  @app ||= Custom::Application.new(self, template_dir)
end

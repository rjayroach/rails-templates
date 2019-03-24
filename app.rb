# require 'pry'
module Custom
  class Application
    attr_reader :parent_dir, :app_dir, :application_name, :controllers_path, :is_plugin, :template_path
    attr_reader :gems, :gemfile, :append_files, :copy_dirs, :ros
    attr_accessor :selected, :whitelist, :blacklist, :content_files, :current_component

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

    def copy_to_dir(target, source = nil, apply = :later)
      source ||= target
      if apply.eql? :now
        Dir["#{template_dir}/roles/#{current_component}/files/#{source}/*"].each do |file|
          FileUtils.cp(file, target)
        end
      end
    end

    # app.append_to_file 'db/seeds.rb', 'iam/files/seeds.rb'
    # app.append_to_file 'README.md'
    def append_to_file(target, source = nil, apply = :later)
      source ||= target
      if apply.eql? :now
        to_append = File.read("#{template_dir}/roles/#{current_component}/files/#{source}")
        File.open("#{target}", 'a') { |file| file.puts to_append }
        return
      end
      @append_files << {
        source: "#{template_dir}/roles/#{current_component}/files/#{source}",
        target: target
      }
    end

    def load_yaml
      yml = YAML.load_file(yml_file)
      return unless name = yml['configure']
      @whitelist = yml[name]['whitelist'] if yml[name]['whitelist']
      @blacklist = yml[name]['blacklist'] if yml[name]['blacklist']
      @gemfile = yml[name]['gemfile'] if yml[name]['gemfile']
      @ros = OpenStruct.new(yml[name]['ros'])
    end

    def initialize(rails_generator, template_path)
      @append_files = []
      @template_path = template_path
      @is_plugin =  rails_generator.class.name.eql? 'Rails::Generators::PluginGenerator'
      @parent_dir = Pathname.new(Dir.pwd).parent.to_s
      @app_dir = is_plugin ? 'spec/dummy' : '.'

      # NOTE: If the template is invoked with 'rails new <name>' then @app_name will be the value of <name>
      # However, if the template is invoked with 'rails plugin new <name>' then @app_name will be nil
      @application_name = is_plugin ? rails_generator.instance_variable_get('@name')
        : rails_generator.instance_variable_get('@app_name')

      @controllers_path = is_plugin ? "app/controllers/#{@name}" : 'app/controllers'

      @selected = []
      @content_files = []
      @whitelist = []
      @blacklist = []
      @gems = {}
      @gem_group = 'all'
      load_yaml if File.exists?(yml_file)
      @gemfile ||= {}
      @gemfile['blacklist'] ||= []
      @gemfile['whitelist'] ||= []
      self
    end

    def yml_file
      # TODO: if -T is passed and no --dummy-path is passed then no dummy dir is created and db:seed cannot be run
      #       also the path to rails-template is '..' rather the '../../..'
      # TODO: Find a variable in rails generator that indicates what dummy-path is and handle it
      # binding.pry
      @yml_file ||= "#{File.expand_path((plugin? ? '../../..' : '..'))}/rails-template.yml"
      # @yml_file ||= "#{File.expand_path(('..'))}/rails-template.yml"
    end

    def gem(*name)
      @gems[@gem_group] ||= {}
      @gems[@gem_group][name.shift] = name.shift
    end

    def gem_group(*groups, &block)
      @gem_group = groups.sort.join('&')
      yield
      @gem_group = 'all'
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
  # Look for the white/black lists of services in the directory in which rails new was run
  @app ||= Custom::Application.new(self, template_dir)
end

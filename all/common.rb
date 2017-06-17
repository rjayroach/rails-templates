def asker(code, text)
  @packages << code if @packages.exclude?(code) && yes?(text)
end

# NOTE: If the template is invoked with 'rails new <name>' then @app_name will be the value if <name>
# However, if the template is invoked with 'rails plugin new <name>' then @app_name will be nil
def plugin?
  self.class.name.eql? 'Rails::Generators::PluginGenerator'
end

@parent_dir = Dir.pwd.split('/').reverse.drop(1).reverse.join('/')
@app_dir = plugin? ? dummy_path : '.'
@application_name = plugin? ? @name : @app_name

@controllers_path = plugin? ? "app/controllers/#{@name}" : 'app/controllers'

@packages = []

# wrap git :init with #inside b/c otherwise when a plugin is create pwd is dummy_path
inside('.') { git :init }
create_file '.env'

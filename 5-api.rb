require_relative 'setup'
def source_paths; Array(super) + [Pathname.new(template_dir), "#{Pathname.new(template_dir)}/roles"] end
apply('common.rb')

app.whitelist = %w(config defaults docker)
app.blacklist = %w(trailblazer rubocop)
app.ask

app.applied.each do |component|
  next unless File.exists?("#{template_dir}/roles/#{component}/tasks/pre.rb") 
  apply("roles/#{component}/tasks/pre.rb")
end

gem 'therubyracer', platforms: :ruby

if not app.plugin?
  apply('roles/application/tasks/pre.rb')
elsif full? || mountable?
  apply('roles/plugin/tasks/pre.rb')
end

after_bundle do
  # wrap with #inside b/c otherwise when a plugin is created pwd is dummy_path
  inside('.') do
    run 'spring stop'
    app.applied.each do |component|
      next unless File.exists?("#{template_dir}/roles/#{component}/tasks/post.rb") 
      apply("roles/#{component}/tasks/post.rb")
    end
    run 'spring stop'
  end
end

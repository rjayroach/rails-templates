# Prompt user for roles to apply
app.ask

# wrap git :init with #inside b/c otherwise when a plugin is create pwd is dummy_path
inside('.') { git :init }

# Initialize each role, e.g. .dockerignore, Guardfile, etc are created
# Then apply main part of each role, e.g. cross role append_file commands can go here
%w(init main).each do |file|
  app.applied.each do |component|
    next unless File.exists?("#{template_dir}/roles/#{component}/tasks/#{file}.rb")
    apply("roles/#{component}/tasks/#{file}.rb")
  end
end

# Append each role's README.md and Guardfile contents to project's README.md and Guardfile if they exist
app.content_files.each do |target|
  app.applied.each do |component|
    source = "#{template_dir}/roles/#{component}/files/#{target}"
    append_to_file(target, File.read(source)) if File.exists?(source)
  end
end

if not app.plugin?
  apply('roles/application/tasks/main.rb')
elsif full? || mountable?
  apply('roles/plugin/tasks/main.rb')
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

# Prompt user for roles to apply
app.ask

# Initialize each role, e.g. .dockerignore, Guardfile, etc are created
# Then apply main part of each role, e.g. cross role append_file commands can go here
%w(init main).each do |file|
  app.applied.each do |component|
    next unless File.exists?("#{template_dir}/roles/#{component}/tasks/#{file}.rb")
    apply("roles/#{component}/tasks/#{file}.rb")
  end
end

### Modify Gemfile
# Remove full line comments from Gemfile
gsub_file('Gemfile', /^\s*#.*\n/, '') if app.gemfile['remove_comments']

# Remove blacklisted gems from rails generated Gemfile
app.gemfile['blacklist'].each do |name|
  gsub_file('Gemfile', /^gem\s+["']#{name}["'].*$/, '')
end

app.gemfile['whitelist'].each do |name|
  gem name
end

# Add requested gems
app.gems.each do |group, gems|
  gems.each { |name, attributes| gem name, attributes } if group.eql? 'all'
  gem_group group.split('&').map(&:to_sym) do
    gems.each { |name, attributes| gem name, attributes }
  end unless group.eql? 'all'
end

# Remove [ and ] from group names
gsub_file('Gemfile', 'group [', 'group ')
gsub_file('Gemfile', '] do', ' do')

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

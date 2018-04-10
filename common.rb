
# wrap git :init with #inside b/c otherwise when a plugin is create pwd is dummy_path
inside('.') { git :init }
create_file '.env'
create_file 'Procfile'

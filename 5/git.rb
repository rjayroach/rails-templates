append_file '.gitignore', ".env\n"
append_file '.gitignore', ".env.local\n"
append_file '.gitignore', "spec/dummy/Gemfile.lock\n" if @type.eql?(:plugin)
# NOTE: config/environment.rb is not ignored in Engines b/c the absence of that file causes Rails.vim to segfault
# append_file('.gitignore', "config/environment.rb\n") if @type.eql?(:plugin)
git add: '.'
git commit: "-a -m 'Initial commit'"

# rails-templates

http://guides.rubyonrails.org/rails_application_templates.html

```bash
$ rails new blog -m https://raw.githubusercontent.com/rjayroach/rails-templates/master/4-main.rb
```

```bash
$ bin/rake rails:template LOCATION=https://raw.githubusercontent.com/rjayroach/rails-templates/master/5-api.rb
```

```bash
$ rails new todo-app --api -m https://raw.githubusercontent.com/rjayroach/rails-templates/master/5-api.rb
```

```bash
$ rails new todo-app --api -m path-to-rails-templates/5-api.rb
```

```bash
$ rails plugin new todo-engine --api --full -m path-to-rails-templates/5-api.rb -T --dummy-path=spec/dummy
```

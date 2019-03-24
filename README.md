# rails-templates

http://guides.rubyonrails.org/rails_application_templates.html

```bash
rails new todo-app -m https://raw.githubusercontent.com/rjayroach/rails-templates/master/4-main.rb
```

```bash
bin/rake rails:template LOCATION=https://raw.githubusercontent.com/rjayroach/rails-templates/master/5-api.rb
```

```bash
rails new todo-app --api -m https://raw.githubusercontent.com/rjayroach/rails-templates/master/5-api.rb
```

```bash
rails new todo-app --api -m path-to-rails-templates/5-api.rb
```

## Plugins

A Rails plug-in is just a bare bones gem with a railtie

Passing the `--full` option will create a full app structure which is aka an engine

Passing the `--mountable` additionally adds `isolate_namespace = true` and requires to mount engine routes
in the application's config/routes.rb

```bash
rails plugin new todo-engine --api --full -m path-to-rails-templates/5-api.rb -T --dummy-path=spec/dummy
```

## TODO

- fix up slack role so it is immediately configured
- test applying the template to an existing project to add, e.g. grpc.
- Implement https://github.com/brigade/overcommit

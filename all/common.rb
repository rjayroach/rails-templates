def asker(code, text)
  @packages << code unless @packages.include?(code) || no?(text)
end

@type = :app
@type = :plugin if @app_name.nil?
@parent_dir = Dir.pwd.split('/').reverse.drop(1).reverse.join('/')

@packages = []

git :init
create_file '.env'

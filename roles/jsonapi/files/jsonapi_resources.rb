JSONAPI.configure do |config|
  #:underscored_key, :camelized_key, :dasherized_key, or custom
  config.json_key_format = :underscored_key
  #:underscored_route, :camelized_route, :dasherized_route, or custom
  config.route_format = :underscored_route

  # built in paginators are :none, :offset, :paged
  config.default_paginator = :offset

  config.default_page_size = 10
  config.maximum_page_size = 20
end

Mime::Type.register 'application/json-patch+json', :json_patch

<% if app.plugin? -%>
<%= "module #{@name.classify}" %>
<% end -%>
class HealthController < ActionController::API
  def index
    render plain: 'ok', status: :ok
  end
end
<% if app.plugin? -%>
end
<% end -%>

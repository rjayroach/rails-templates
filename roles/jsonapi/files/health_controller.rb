<% if app.plugin? -%>
<%= "module #{@name.classify}" %>
<% end -%>
class HealthController < ActionController::API
  def index
    render text: 'ok', status: :ok
  end
end
<% if app.plugin? -%>
end
<% end -%>
defmodule CasWeb.LayoutView do
  use CasWeb, :view

  alias Cas.Model.User

  def get_name_from_user(username) do
    user = User.get_name(username)
    user.name
  end
end

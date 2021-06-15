defmodule CasWeb.PageController do
  use CasWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

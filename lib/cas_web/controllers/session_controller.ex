defmodule CasWeb.SessionController do
  use CasWeb, :controller

  alias Cas.Oauth.Cas

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"username" => username, "password" => password} = params) do
    case Cas.authorize_url(params) do
      {:ok, token_info} ->
        conn
        |> CasWeb.Auth.login(token_info)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Combinación de usuario/contraseña invalida")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CasWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end

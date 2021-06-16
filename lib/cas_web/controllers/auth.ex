defmodule CasWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias CasWeb.Router.Helpers, as: Routes
  alias Cas.Network.Menu
  alias Cas.Oauth.Cas

  def init(opts), do: opts

  def call(conn, _opts) do
    token_info = get_session(conn, :user_token)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)

      user = token_info ->
        put_current_user(conn, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, token_info) do
    menu = Menu.get_menu(token_info.username, token_info)
    menu = struct(Menu, menu)
    conn
    |> put_current_user(token_info.username)
    |> put_session(:user_token, menu)
    |> configure_session(renew: true)
  end

  defp put_current_user(conn, user) do
    conn
    |> assign(:current_user, user)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def authenticate_user(conn, _opts) do
    user_info = conn.assigns.current_user
    if user_info do
      user_info.access_token
        |> Cas.validate_token()
        |> case do
          :ok ->
            conn
              |> put_flash(:error, "Sesión expirada, inicia sesión nuevamente")
              |> logout()
              |> redirect(to: Routes.session_path(conn, :new))
          _body ->
            conn
        end
    else
      conn
      |> put_flash(:error, "Necesitas estar logueado para entrar a esta página")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end

end

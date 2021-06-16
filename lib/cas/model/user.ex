defmodule Cas.Model.User do
  @moduledoc false
  defstruct id_banner: nil, id_rol: nil, name: nil, rol: nil, username: nil, id_user: nil, rectoria: false

  alias __MODULE__
  alias Cas.Network.ManagerRequest

  @security_url Application.get_env(:cas, CasWeb.Endpoint)[:security_config]

  def get_name(username) do
    "#{@security_url}v1/api/users/roles?userName=#{username}&portalName=faltas-y-suplencias"
    |> ManagerRequest.get_security_user()
    |> case do
      :ok ->
        nil
      user ->
        user |> parser_username(username) |> List.first() |> Map.from_struct()
    end
  end

  def parser_username(user_list, username) do
    for n <- user_list, do: %User{id_banner: n["idBanner"], id_rol: n["idRol"], name: n["name"], rol: n["rol"], username: username}
  end

end

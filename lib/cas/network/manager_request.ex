defmodule Cas.Network.ManagerRequest do
  @moduledoc false

  require Logger

  @security_url Application.get_env(:cas, CasWeb.Endpoint)[:security_config]

  def get_security_user(url) do
    HTTPoison.get("#{@security_url}#{url}")
    |> case do
      {:ok, response } ->
        case response.status_code do
          200 ->
            Poison.decode!(response.body)
          302 ->
            Poison.decode!(response.body)
          404 ->
            IO.puts "No encontrado :("
          500 ->
            IO.puts "Errorz D:"
        end
      _ -> "Request error :O"
    end
  end

  def get_security_user(url, query_params) do
    options = [params: Map.to_list(query_params), timeout: 50_000, recv_timeout: 50_000]
    response = HTTPoison.request!(:get, "#{@security_url}#{url}", "{}", [{"Accept", "application/json"}], options)
    case response.status_code do
      200 ->
        {:ok, Poison.decode!(response.body)}
      400 ->
        {:error, :client_error}
      500 ->
        {:error, :server_error}
      _ ->
        {:error, :unknown_error}
    end
  end
end

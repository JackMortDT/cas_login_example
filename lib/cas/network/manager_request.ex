defmodule Cas.Network.ManagerRequest do
  @moduledoc false

  require Logger

  def get_security_user(url, headers \\ []) do
    HTTPoison.get(url, headers)
    |> case do
      {:ok, response } ->
        case response.status_code do
          200 ->
            Poison.decode!(response.body)
          302 ->
            Poison.decode!(response.body)
          401 ->
            IO.puts "unauthorized"
          404 ->
            IO.puts "No encontrado :("
          500 ->
            IO.puts "Errorz D:"
        end
      _ -> "Request error :O"
    end
  end
end

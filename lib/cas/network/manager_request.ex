defmodule Cas.Network.ManagerRequest do
  @moduledoc false

  require Logger

  @security_url Application.get_env(:cas, Cas.Endpoint)[:security_config]

  def get_security_user(url) do
    case HTTPoison.get("#{@security_url}#{url}") do
      {:ok, %HTTPoison.Response{status_code: 302, body: body}} ->
        Poison.decode!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end

defmodule Cas.Oauth.Cas do
  @moduledoc """
  An OAuth2 strategy for CAS.
  """
  use OAuth2.Strategy

  alias Cas.Network.ManagerRequest

  def client(params) do
    OAuth2.Client.new([
      strategy: OAuth2.Strategy.Password,
      site: "https://cas-qa.ebc.edu.mx",
      authorize_url: "https://cas-qa.ebc.edu.mx/cas/oidc/authorize",
      token_url: "https://cas-qa.ebc.edu.mx/cas/oidc/accessToken",
      redirect_uri: "http://localhost:4000/auth/callback",
      client_id: "TestService",
      client_secret: "imNotASecret",
      params: params
    ])
  end

  def authorize_url(%{"username" => username, "password" => _password} = params) do
    params
    |> client()
    |> OAuth2.Client.get_token([])
    |> case do
      {:ok, token} ->
        token_info =
          token_info(token)
          |> Map.put(:username, username)
        {:ok, token_info}
      other -> other
    end
  end

  defp token_info(response) do
    token_response = response |> Map.get(:token)
    token_response.access_token
    |> Cas.Serializer.decode!()
    |> Cas.Util.GeneralUtil.convert_map()
  end

  def validate_token(token) do
    url = "https://cas-qa.ebc.edu.mx/cas/oidc/profile"
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8"]
    ManagerRequest.get_security_user(url, headers)
  end
end

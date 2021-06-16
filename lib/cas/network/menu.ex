defmodule Cas.Network.Menu do
  @moduledoc false
  defstruct id: nil, short_name: nil, url: nil, level: nil, accessProfile: [], profile: nil, divisions: [], access_token: ""

  alias Cas.Network.ManagerRequest
  alias Cas.Util.GeneralUtil

  alias __MODULE__

  @security_url Application.get_env(:cas, CasWeb.Endpoint)[:security_config]

  def get_menu(name, token_info) do
    ManagerRequest.get_security_user("#{@security_url}/v2/api/user/profile/#{name}/faltas-y-suplencias")
    |> case do
      :ok ->
        %Menu{}
      menu ->
        menu = menu |> GeneralUtil.convert_map()
        parsed_menu = parser_menu(menu.access_profile)
        :ets.insert(:list_menus, {name, parsed_menu})
        %{
          short_name: menu.short_name,
          access_profile: %{},
          url: menu.url,
          level: menu.level,
          profile: name,
          division: get_campus_and_division(name),
          access_token: token_info.access_token,
          id: token_info.access_token
        }
    end
  end

  def parser_menu(access_profile) do
    for profile <- access_profile do
      %{
        short_name: profile["shortName"],
        url: profile["url"],
        level: profile["level"],
        access_profile: parser_menu(profile["accessProfile"])
      }
    end
  end

  def get_campus_and_division(name) do
    case ManagerRequest.get_security_user("#{@security_url}v2/api/user/#{name}/portal/faltas-y-suplencias") do
      :ok ->
        []
      profile ->
        Enum.map(profile["divisions"], fn division ->
          %{division_code: division["divisionCode"],
            campus: division["campuses"]}
        end)
    end
  end
end

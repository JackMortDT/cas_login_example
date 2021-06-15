defmodule Cas.Network.Menu do
  @moduledoc false
  defstruct short_name: nil, url: nil, level: nil, accessProfile: [], profile: nil, divisions: []
  alias Cas.Network.ManagerRequest

  alias __MODULE__

  def get_menu(name) do
    case ManagerRequest.get_security_user("/v2/api/user/profile/#{name}/faltas-y-suplencias") do
      :ok ->
        %Menu{}
      menu ->
        parsed_menu = parser_menu(menu.access_profile)
        :ets.insert(:list_menus, {name, parsed_menu})
        %{
          short_name: menu.short_name,
          access_profile: %{},
          url: menu.url,
          level: menu.level,
          profile: name,
          division: get_campus_and_division(name)
        }
    end
  end

  def parser_menu(access_profile) do
    for profile <- access_profile do
      %{
        short_name: profile.short_name,
        url: profile.url,
        level: profile.level,
        access_profile: parser_menu(profile.access_profile)
      }
    end
  end

  def get_campus_and_division(name) do
    case ManagerRequest.get_api_security("v2/api/user/#{name}/portal/faltas-y-suplencias") do
      :ok ->
        []
      profile ->
        Enum.map(profile.divisions, fn division ->
          %{division_code: division.division_code,
            campus: division.campuses}
        end)
    end
  end
end

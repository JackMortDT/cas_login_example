defmodule Cas.Util.GeneralUtil do

  @doc """
    Convert string map to atom map

    ## Example

      iex> convert_map(%{"example" => "example"})
      %{example: "example"}
  """
  def convert_map(map) do
    for {key, val} <- map, into: %{} do
      {key |> Macro.underscore() |> String.to_atom(), val}
    end
  end
end

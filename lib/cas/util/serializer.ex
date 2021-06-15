defmodule Cas.Serializer do
  def encode!(data), do: Jason.encode!(data)
  def decode!(binary), do: Jason.decode!(binary)
end

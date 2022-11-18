defmodule BlogoWeb.Graphql.Types.Scalar.UUID do
  @moduledoc """
  The `UUID` scalar type represents a version 4 UUID.
  """
  use Absinthe.Schema.Notation

  scalar :uuid, name: "UUID" do
    serialize(&deafult_serialize/1)
    parse(&parse_uuid/1)
  end

  @spec parse_uuid(Absinthe.Blueprint.Input.String.t()) :: {:ok, Ecto.UUID} | :error
  @spec parse_uuid(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_uuid(%Absinthe.Blueprint.Input.String{value: value}), do: Ecto.UUID.cast(value)

  defp parse_uuid(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}

  defp parse_uuid(_), do: :error

  defp deafult_serialize(value), do: value
end

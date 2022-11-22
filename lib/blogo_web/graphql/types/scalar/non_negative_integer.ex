defmodule BlogoWeb.Graphql.Types.Scalar.NonNegativeInteger do
  @moduledoc """
  The `NonNegativeInteger` scalar type represents an integer equal or greater than zero.
  """
  use Absinthe.Schema.Notation

  scalar :non_negative_integer, name: "NonNegativeInteger" do
    serialize(&deafult_serialize/1)
    parse(&parse_non_negative_integer/1)
  end

  @spec parse_non_negative_integer(Absinthe.Blueprint.Input.String.t()) ::
          {:ok, non_neg_integer()} | :error
  @spec parse_non_negative_integer(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_non_negative_integer(%Absinthe.Blueprint.Input.String{value: value}) do
    if is_integer(value) and value >= 0 do
      {:ok, String.to_integer(value)}
    else
      :error
    end
  end

  defp parse_non_negative_integer(%Absinthe.Blueprint.Input.Integer{value: value}) do
    if is_integer(value) and value >= 0 do
      {:ok, value}
    else
      :error
    end
  end

  defp parse_non_negative_integer(%Absinthe.Blueprint.Input.Null{}), do: {:ok, nil}

  defp parse_non_negative_integer(_), do: :error

  defp deafult_serialize(value), do: value
end

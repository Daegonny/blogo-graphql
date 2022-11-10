defmodule BlogoWeb.Graphql.Types.Sorting do
  @moduledoc """
  Useful sorting types
  """
  use Absinthe.Schema.Notation

  enum :sorting_order do
    value(:asc)
    value(:desc)
  end
end

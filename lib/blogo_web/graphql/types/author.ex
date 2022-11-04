defmodule BlogoWeb.Graphql.Types.Author do
  @moduledoc """
  Author graphql object
  """
  use Absinthe.Schema.Notation

  object :author do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:age, non_null(:integer))
    field(:country, non_null(:string))
  end
end

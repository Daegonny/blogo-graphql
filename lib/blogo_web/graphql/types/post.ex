defmodule BlogoWeb.Graphql.Types.Post do
  @moduledoc """
  Post graphql object
  """
  use Absinthe.Schema.Notation

  object :post do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:views, non_null(:integer))
  end
end

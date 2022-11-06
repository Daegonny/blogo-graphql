defmodule BlogoWeb.Graphql.Types.Author do
  @moduledoc """
  Author graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :author do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:age, non_null(:integer))
    field(:country, non_null(:string))

    field(:posts, non_null(list_of(:post))) do
      resolve(&Resolvers.Post.by_author/3)
    end
  end
end

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
      arg(:query_params, :post_query_params)
      resolve(&Resolvers.Post.by_author/3)
    end

    field(:tags, non_null(list_of(:tag))) do
      arg(:names, list_of(:string))
      resolve(&Resolvers.Tag.by_author/3)
    end
  end
end

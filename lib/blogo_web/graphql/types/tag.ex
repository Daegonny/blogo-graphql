defmodule BlogoWeb.Graphql.Types.Tag do
  @moduledoc """
  Tag graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :tag do
    field(:id, non_null(:id))
    field(:name, non_null(:string))

    field(:authors, non_null(list_of(:author))) do
      resolve(&Resolvers.Author.by_tag/3)
    end

    field(:posts, non_null(list_of(:post))) do
      arg(:query_params, :post_query_params)
      resolve(&Resolvers.Post.by_tag/3)
    end
  end
end

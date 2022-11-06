defmodule BlogoWeb.Graphql.Types.Post do
  @moduledoc """
  Post graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :post do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:views, non_null(:integer))

    field(:tags, non_null(list_of(:tag))) do
      resolve(&Resolvers.Tag.by_post/3)
    end

    field(:authors, non_null(list_of(:author))) do
      resolve(&Resolvers.Author.by_post/3)
    end
  end
end

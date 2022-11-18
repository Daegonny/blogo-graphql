defmodule BlogoWeb.Graphql.Queries.Tag do
  @moduledoc """
  Tag graphql queries
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :tag_queries do
    @desc "Get tag by id"
    field :tag, :tag do
      arg(:id, non_null(:uuid))
      resolve(&Resolvers.Tag.get/3)
    end

    @desc "Get all tags"
    field :tags, list_of(:tag) do
      arg(:query_params, :tag_query_params)
      resolve(&Resolvers.Tag.all/3)
    end
  end
end

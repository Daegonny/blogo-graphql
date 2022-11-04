defmodule BlogoWeb.Graphql.Queries.Tag do
  @moduledoc """
  Tag graphql queries
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :tag_queries do
    @desc "Get tag by id"
    field :tag, :tag do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Tag.get/3)
    end

    @desc "Get all tags"
    field :tags, list_of(:tag) do
      resolve(&Resolvers.Tag.all/3)
    end
  end
end

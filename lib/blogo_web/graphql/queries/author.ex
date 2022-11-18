defmodule BlogoWeb.Graphql.Queries.Author do
  @moduledoc """
  Author graphql queries
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :author_queries do
    @desc "Get author by id"
    field :author, :author do
      arg(:id, non_null(:uuid))
      resolve(&Resolvers.Author.get/3)
    end

    @desc "Get all authors"
    field :authors, list_of(:author) do
      arg(:query_params, :author_query_params)
      resolve(&Resolvers.Author.all/3)
    end
  end
end

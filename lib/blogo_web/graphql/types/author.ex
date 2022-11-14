defmodule BlogoWeb.Graphql.Types.Author do
  @moduledoc """
  Author graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  @desc "Object"
  object :author do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:age, non_null(:integer))
    field(:country, non_null(:string))
    field(:inserted_at, non_null(:string))

    field(:posts, non_null(list_of(:post))) do
      arg(:query_params, :post_query_params)
      resolve(&Resolvers.Post.by_author/3)
    end

    field(:tags, non_null(list_of(:tag))) do
      arg(:query_params, :tag_query_params)
      resolve(&Resolvers.Tag.by_author/3)
    end
  end

  @desc "Query input params"
  input_object :author_query_params do
    field(:limit, :integer)
    field(:sort_by, list_of(:author_sorter))
    field(:filters, :author_filter)
  end

  @desc "Available filtering fields"
  input_object :author_filter do
    field(:text_search, :string)
    field(:min_age, :integer)
    field(:max_age, :integer)
  end

  @desc "Sorter"
  input_object :author_sorter do
    field(:field, non_null(:author_sorting_field))
    field(:order, non_null(:sorting_order))
  end

  @desc "Available sorting fields"
  enum :author_sorting_field do
    value(:name)
    value(:country)
    value(:age)
  end
end

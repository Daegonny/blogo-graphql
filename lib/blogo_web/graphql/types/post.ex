defmodule BlogoWeb.Graphql.Types.Post do
  @moduledoc """
  Post graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  @desc "Object"
  object :post do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:content, non_null(:string))
    field(:views, non_null(:integer))
    field(:inserted_at, non_null(:string))

    field(:tags, non_null(list_of(:tag))) do
      arg(:query_params, :tag_query_params)
      resolve(&Resolvers.Tag.by_post/3)
    end

    field(:authors, non_null(list_of(:author))) do
      arg(:query_params, :author_query_params)
      resolve(&Resolvers.Author.by_post/3)
    end
  end

  @desc "Query input params"
  input_object :post_query_params do
    field(:limit, :integer)
    field(:sort_by, list_of(:post_sorter))
    field(:filters, :post_filter)
  end

  @desc "Available filtering fields"
  input_object :post_filter do
    field(:text_search, :string)
    field(:min_views, :integer)
    field(:max_views, :integer)
    field(:min_inserted_at, :string)
    field(:max_inserted_at, :string)
  end

  @desc "Sorter"
  input_object :post_sorter do
    field(:field, non_null(:post_sorting_field))
    field(:order, non_null(:sorting_order))
  end

  @desc "Available sorting fields"
  enum :post_sorting_field do
    value(:title)
    value(:content)
    value(:views)
    value(:inserted_at)
  end
end

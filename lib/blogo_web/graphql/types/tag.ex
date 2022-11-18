defmodule BlogoWeb.Graphql.Types.Tag do
  @moduledoc """
  Tag graphql object
  """
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  @desc "Object"
  object :tag do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:inserted_at, non_null(:date_time))

    field(:authors, non_null(list_of(:author))) do
      arg(:query_params, :author_query_params)
      resolve(&Resolvers.Author.by_tag/3)
    end

    field(:posts, non_null(list_of(:post))) do
      arg(:query_params, :post_query_params)
      resolve(&Resolvers.Post.by_tag/3)
    end
  end

  @desc "Query input params"
  input_object :tag_query_params do
    field(:limit, :integer)
    field(:sort_by, list_of(:tag_sorter))
    field(:filters, :tag_filter)
  end

  @desc "Available filtering fields"
  input_object :tag_filter do
    field(:text_search, :string)
    field(:min_inserted_at, :date_time)
    field(:max_inserted_at, :date_time)
  end

  @desc "Sorter"
  input_object :tag_sorter do
    field(:field, non_null(:tag_sorting_field))
    field(:order, non_null(:sorting_order))
  end

  @desc "Available sorting fields"
  enum :tag_sorting_field do
    value(:name)
    value(:inserted_at)
  end
end

defmodule Blogo.Tags.TagQueries do
  @moduledoc """
  Tag repo queries context
  """
  import Ecto.Query
  import Blogo.Repo, only: [build_query: 3]
  alias Blogo.Tag

  @doc """
  Builds a tag query with filters, limit and order_by params
  """
  @spec build(map()) :: Ecto.Query.t()
  def build(params), do: build_query(params, Tag, &filter_query/2)

  defp filter_query(query, filters) do
    Enum.reduce(filters, query, fn
      {:text_search, value}, query ->
        downcase_value = String.downcase(value)

        where(
          query,
          [tag],
          ilike(tag.name, ^"%#{downcase_value}%")
        )

      {:min_inserted_at, value}, query ->
        where(query, [tag], tag.inserted_at >= ^value)

      {:max_inserted_at, value}, query ->
        where(query, [tag], tag.inserted_at <= ^value)

      _, query ->
        query
    end)
  end
end

defmodule Blogo.Authors.AuthorQueries do
  @moduledoc """
  Author repo queries context
  """
  import Ecto.Query
  import Blogo.Repo, only: [build_query: 3]
  alias Blogo.Author

  @doc """
  Builds a author query with filters, limit and order_by params
  """
  @spec build(map()) :: Ecto.Query.t()
  def build(params), do: build_query(params, Author, &filter_query/2)

  defp filter_query(query, filters) do
    Enum.reduce(filters, query, fn
      {:text_search, value}, query ->
        downcase_value = String.downcase(value)

        where(
          query,
          [author],
          ilike(author.name, ^"%#{downcase_value}%") or
            ilike(author.country, ^"%#{downcase_value}%")
        )

      {:min_age, value}, query ->
        where(query, [author], author.age >= ^value)

      {:max_age, value}, query ->
        where(query, [author], author.age <= ^value)

      {:min_inserted_at, value}, query ->
        where(query, [author], author.inserted_at >= ^value)

      {:max_inserted_at, value}, query ->
        where(query, [author], author.inserted_at <= ^value)

      _, query ->
        query
    end)
  end
end

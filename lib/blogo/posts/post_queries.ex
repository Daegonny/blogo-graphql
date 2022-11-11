defmodule Blogo.Posts.PostQueries do
  @moduledoc """
  Post repo queries context
  """
  import Ecto.Query
  import Blogo.Repo, only: [build_query: 3]
  alias Blogo.Post

  @doc """
  Builds a query with filters, limit and order_by params
  """
  @spec build(map()) :: Ecto.Query.t()
  def build(params), do: build_query(params, Post, &filter_query/2)

  defp filter_query(query, filters) do
    Enum.reduce(filters, query, fn
      {:text_search, value}, query ->
        where(
          query,
          [post],
          ilike(post.title, ^"%#{value}%") or ilike(post.content, ^"%#{value}%")
        )

      {:min_views, value}, query ->
        where(query, [post], post.views >= ^value)

      {:max_views, value}, query ->
        where(query, [post], post.views <= ^value)

      {:min_inserted_at, value}, query ->
        where(query, [post], post.inserted_at >= ^value)

      {:max_inserted_at, value}, query ->
        where(query, [post], post.inserted_at <= ^value)

      _, query ->
        query
    end)
  end
end

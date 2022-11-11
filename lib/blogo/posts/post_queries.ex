defmodule Blogo.Posts.PostQueries do
  @moduledoc """
  Post repo queries context
  """
  import Ecto.Query
  alias Blogo.Post

  @doc """
  Builds a query with filters, limit and order_by params
  """
  @spec build(map()) :: Ecto.Query.t()
  def build(params) do
    Enum.reduce(params, Post, fn
      {:limit, limit}, query ->
        limit_query(query, limit)

      {:filters, filters}, query ->
        filter_query(query, filters)

      {:sort_by, sorters}, query ->
        sort_query(query, sorters)

      _, query ->
        query
    end)
  end

  defp limit_query(query, limit), do: limit(query, ^limit)

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

  defp sort_query(query, sorters) when is_list(sorters) do
    map_to_tuple = fn %{field: field, order: order} -> {order, field} end
    order = Enum.map(sorters, map_to_tuple)
    order_by(query, ^order)
  end
end

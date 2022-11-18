defmodule BlogoWeb.Graphql.Middlewares.DepthLimit do
  @moduledoc """
  Absinthe middleware for limiting max depth on queries.
  """

  @behaviour Absinthe.Middleware

  @impl true
  def call(resolution, _config) do
    if depth(resolution.definition.selections) > query_depth_limit() do
      Absinthe.Resolution.put_result(resolution, {:error, :query_depth_limit_exceeded})
    else
      resolution
    end
  end

  defp depth(selections, depth \\ 0)
  defp depth([], depth), do: depth

  defp depth(selections, depth) do
    selections
    |> Enum.map(&depth(&1.selections, depth + 1))
    |> Enum.max()
  end

  defp query_depth_limit, do: Application.fetch_env!(:blogo, :query_depth_limit)
end

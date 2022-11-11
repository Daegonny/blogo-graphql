defmodule Blogo.Repo do
  use Ecto.Repo,
    otp_app: :blogo,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query

  @spec build_query(map(), atom(), (Ecto.Query.t(), map() -> Ecto.Query.t())) :: Ecto.Query.t()
  def build_query(params, schema, filter) do
    Enum.reduce(params, schema, fn
      {:limit, value}, query ->
        limit(query, ^value)

      {:filters, value}, query ->
        filter.(query, value)

      {:sort_by, value}, query ->
        sort_query(query, value)

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

defmodule Blogo.Tags do
  @moduledoc """
  Tag context
  """
  alias Blogo.Tags.TagQueries
  alias Blogo.{Repo, Tag}

  @doc """
  Get a tag by id.
  """
  @spec get(binary()) :: Tag.t() | nil
  def get(id) do
    Repo.get(Tag, id)
  end

  @type tag_query_params :: %{
          limit: non_neg_integer(),
          filters: %{
            search_text: String.t(),
            min_inserted_at: DateTime.t(),
            max_inserted_at: DateTime.t()
          },
          sort_by: list(%{field: String.t(), order: atom()})
        }

  @doc """
  Load tags with filters, limit and order_by params
  * :limit -> limits the result list size
  * :sort_by -> sort results ascending or descending by following fields:
    - :name
    - :inserted_at
  * :filters -> filter results according by following criterias:
    - :search_text -> :name case insensitive match ('%value%')
    - :min_inserted_at -> :inserted_at after or equal DateTime value
    - :max_inserted_at -> :inserted_at before or equal DateTime value

  ## Example:
      iex> params = %{
        limit: 10,
        filters: %{
          search_text: "text",
          min_inserted_at: "2001-01-01 00:00:01".
          max_inserted_at: "2020-01-01 00:00:01"
        },
        sort_by: [
          %{ field: :name, order: :asc },
          %{ field: :inserted_at, order: :desc }
        ]
      }
      iex> Blogo.Tags.all(params)
      # [%Tag{...}, ...]
  """
  @spec all(tag_query_params | map()) :: list(Tag.t())
  def all(params \\ %{}) do
    params
    |> TagQueries.build()
    |> Repo.all()
  end
end

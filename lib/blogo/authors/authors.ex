defmodule Blogo.Authors do
  @moduledoc """
  Author context
  """
  alias Faker.DateTime
  alias Blogo.Authors.AuthorQueries
  alias Blogo.{Author, Repo}

  @doc """
  Get an author by id.
  """
  @spec get(binary()) :: Author.t() | nil
  def get(id), do: Repo.get(Author, id)

  @type author_query_params :: %{
          limit: non_neg_integer(),
          filters: %{
            search_text: String.t(),
            min_age: non_neg_integer(),
            max_age: non_neg_integer(),
            min_inserted_at: DateTime.t(),
            max_inserted_at: DateTime.t()
          },
          sort_by: list(%{field: String.t(), order: atom()})
        }

  @doc """
  Load authors with filters, limit and order_by params
  * :limit -> limits the results list size
  * :sort_by -> sort results ascending or descending by following fields:
    - :name
    - :country
    - :age
    - :inserted_at
  * :filters -> filter results according by following criterias:
    - :search_text -> :name or :country, case insensitive match ('%value%')
    - :min_age -> :age greater or equal than non negative integer value
    - :max_age -> :age lower or equal than non negative integer value
    - :min_inserted_at -> :inserted_at after or equal DateTime value
    - :max_inserted_at -> :inserted_at before or equal DateTime value

  ## Example:
      iex> params = %{
        limit: 10,
        filters: %{
          search_text: "name",
          min_age: 18,
          max_age: 80,
          min_inserted_at: "2001-01-01 00:00:01".
          max_inserted_at: "2020-01-01 00:00:01"
        },
        sort_by: [
          %{ field: :name, order: :asc },
          %{ field: :country, order: :desc },
          %{ field: :age, order: :asc },
          %{ field: :inserted_at, order: :desc }
        ]
      }
      iex> Blogo.Authors.all(params)
      # [%Author{...}, ...]
  """
  @spec all(author_query_params() | map()) :: list(Author.t())
  def all(params \\ %{}) do
    params
    |> AuthorQueries.build()
    |> Repo.all()
  end
end

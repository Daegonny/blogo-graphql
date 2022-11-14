defmodule Blogo.Posts do
  @moduledoc """
  Post context
  """
  alias Blogo.Posts.PostQueries
  alias Blogo.{Post, Repo}

  @doc """
  Get a post by id.
  """
  @spec get(binary()) :: Post.t() | nil
  def get(id), do: Repo.get(Post, id)

  @type post_query_params :: %{
          limit: non_neg_integer(),
          filters: %{
            search_text: String.t(),
            min_views: non_neg_integer(),
            max_views: non_neg_integer(),
            min_inserted_at: DateTime.t(),
            max_inserted_at: DateTime.t()
          },
          sort_by: list(%{field: String.t(), order: atom()})
        }

  @doc """
    Load posts with filters, limit and order_by params
  * :limit -> limits the result list size
  * :sort_by -> sort results ascending or descending by following fields:
    - :title
    - :content
    - :views
    - :inserted_at
  * :filters -> filter results according by following criterias:
    - :search_text -> :title or :content, case insensitive match ('%value%')
    - :min_views -> :min_views greater or equal than non negative integer value
    - :max_views -> :min_views lower or equal than non negative integer value
    - :min_inserted_at -> :inserted_at after or equal DateTime value
    - :max_inserted_at -> :inserted_at before or equal DateTime value

  ## Example:
      iex> params = %{
        limit: 10,
        filters: %{
          search_text: "text",
          min_views: 10,
          max_views: 10_000,
          min_inserted_at: "2001-01-01 00:00:01".
      max_inserted_at: "2020-01-01 00:00:01"
        },
        sort_by: [
          %{ field: :title, order: :asc },
          %{ field: :content, order: :desc },
          %{ field: :views, order: :asc },
          %{ field: :inserted_at, order: :desc }
        ]
      }
      iex> Blogo.Posts.all(params)
      # [%Post{...}, ...]
  """
  @spec all(post_query_params() | map()) :: list(Post.t())
  def all(params \\ %{}) do
    params
    |> PostQueries.build()
    |> Repo.all()
  end
end

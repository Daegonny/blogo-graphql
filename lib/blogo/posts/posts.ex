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
            min_age: non_neg_integer(),
            max_age: non_neg_integer()
          },
          sort_by: list(%{field: String.t(), order: atom()})
        }

  @doc """
    Load posts with filters, limit and order_by params
  - :limit -> limits the result list size
  - :sort_by -> sort results ascending or descending by following fields:
    :title, :content, :views, :inserted_at
  - :filters -> filter results according by following criterias:
    :search_text, :min_age, :max_age

  ## Example:
      iex> params = %{
        limit: 10,
        filters: %{
          search_text: "text",
          min_age: 18,
          max_age: 80
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

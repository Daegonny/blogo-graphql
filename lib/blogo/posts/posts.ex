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

  @spec all(map()) :: list(Post.t())
  def all(params \\ %{}) do
    params
    |> PostQueries.build()
    |> Repo.all()
  end
end

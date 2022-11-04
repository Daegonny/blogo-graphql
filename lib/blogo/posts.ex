defmodule Blogo.Posts do
  @moduledoc """
  Post context
  """
  alias Blogo.{Repo, Post}

  @spec get(binary()) :: struct() | nil
  def get(id) do
    Repo.get(Post, id)
  end

  @spec all() :: list(struct())
  def all() do
    Repo.all(Post)
  end
end

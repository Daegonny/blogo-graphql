defmodule Blogo.Posts do
  @moduledoc """
  Post context
  """
  alias Blogo.{Post, Repo}

  @spec get(binary()) :: Post.t() | nil
  def get(id) do
    Repo.get(Post, id)
  end

  @spec all() :: list(Post.t())
  def all do
    Repo.all(Post)
  end
end

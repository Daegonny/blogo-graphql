defmodule Blogo.Authors do
  @moduledoc """
  Author context
  """
  alias Blogo.{Author, Repo}

  @spec get(binary()) :: struct() | nil
  def get(id), do: Repo.get(Author, id)

  @spec all() :: list(struct())
  def all do
    Repo.all(Author)
  end
end

defmodule Blogo.Authors do
  @moduledoc """
  Author context
  """
  alias Blogo.{Author, Repo}

  @spec get(binary()) :: Author.t() | nil
  def get(id), do: Repo.get(Author, id)

  @spec all() :: list(Author.t())
  def all do
    Repo.all(Author)
  end
end

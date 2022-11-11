defmodule Blogo.Authors do
  @moduledoc """
  Author context
  """
  alias Blogo.Authors.AuthorQueries
  alias Blogo.{Author, Repo}

  @spec get(binary()) :: Author.t() | nil
  def get(id), do: Repo.get(Author, id)

  @spec all(map()) :: list(Author.t())
  def all(params \\ %{}) do
    params
    |> AuthorQueries.build()
    |> Repo.all()
  end
end

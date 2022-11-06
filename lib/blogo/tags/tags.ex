defmodule Blogo.Tags do
  @moduledoc """
  Tag context
  """
  import Ecto.Query
  alias Blogo.{Repo, Tag}

  @spec get(binary()) :: struct() | nil
  def get(id) do
    Repo.get(Tag, id)
  end

  @spec all(map()) :: list(struct())
  def all(params) do
    params
    |> query()
    |> Repo.all()
  end

  def query(args) do
    Enum.reduce(args, Tag, fn
      {:names, names}, query ->
        lower_names = Enum.map(names, &String.downcase/1)
        where(query, [tag], tag.name in ^lower_names)
    end)
  end
end

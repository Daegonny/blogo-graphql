defmodule Blogo.Tags do
  @moduledoc """
  Tag context
  """
  alias Blogo.{Repo, Tag}

  @spec get(binary()) :: struct() | nil
  def get(id) do
    Repo.get(Tag, id)
  end

  @spec all() :: list(struct())
  def all() do
    Repo.all(Tag)
  end
end

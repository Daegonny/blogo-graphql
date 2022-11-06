defmodule Blogo.Repo.DataloaderRepo do
  @moduledoc false
  alias Blogo.Repo

  def query(queryable, _), do: queryable

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end
end

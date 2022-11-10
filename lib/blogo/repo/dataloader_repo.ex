defmodule Blogo.Repo.DataloaderRepo do
  @moduledoc false
  import Absinthe.Resolution.Helpers, only: [on_load: 2]
  alias Blogo.Repo
  alias Blogo.{Post, Tag, Tags}
  alias Blogo.Posts.PostQueries

  def query(Post, args), do: PostQueries.build(args)
  def query(Tag, args), do: Tags.query(args)

  def query(queryable, _), do: queryable

  @spec data :: Dataloader.Ecto.t()
  def data, do: Dataloader.Ecto.new(Repo, query: &query/2)

  def by_parent(parent, field, args, loader) do
    loader
    |> Dataloader.load(__MODULE__, {field, args}, parent)
    |> on_load(fn loader ->
      children = Dataloader.get(loader, __MODULE__, {field, args}, parent)
      {:ok, children}
    end)
  end
end

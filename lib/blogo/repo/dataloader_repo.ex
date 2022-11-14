defmodule Blogo.Repo.DataloaderRepo do
  @moduledoc """
  Dataloader ecto integration helping functions
  """

  import Absinthe.Resolution.Helpers, only: [on_load: 2]
  alias Blogo.Repo
  alias Blogo.{Author, Post, Tag}
  alias Blogo.Authors.AuthorQueries
  alias Blogo.Posts.PostQueries
  alias Blogo.Tags.TagQueries
  alias Ecto.Queryable

  @spec query(Queryable.t(), map()) :: Queryable.t()
  def query(Author, %{query_params: args}), do: AuthorQueries.build(args)
  def query(Post, %{query_params: args}), do: PostQueries.build(args)
  def query(Tag, %{query_params: args}), do: TagQueries.build(args)

  def query(queryable, _), do: queryable

  @spec data :: Dataloader.Ecto.t()
  def data, do: Dataloader.Ecto.new(Repo, query: &query/2)

  @spec by_parent(Queryable.t(), atom(), map(), Dataloader.t()) ::
          {:middleware, Absinthe.Middleware.Dataloader, {any, any}}
  def by_parent(parent, field, args, loader) do
    loader
    |> Dataloader.load(__MODULE__, {field, args}, parent)
    |> on_load(fn loader ->
      children = Dataloader.get(loader, __MODULE__, {field, args}, parent)
      {:ok, children}
    end)
  end
end

defmodule BlogoWeb.Graphql.Resolvers.Post do
  @moduledoc """
  Post graphql resolver
  """
  import Absinthe.Resolution.Helpers, only: [on_load: 2]
  alias Blogo.{Author, Posts}
  alias Blogo.Repo.DataloaderRepo

  def get(_root, %{id: id}, _info) do
    case Posts.get(id) do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end

  def all(_root, _params, _info) do
    {:ok, Posts.all()}
  end

  def by_author(%Author{} = author, args, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(DataloaderRepo, {:posts, args}, author)
    |> on_load(fn loader ->
      posts = Dataloader.get(loader, DataloaderRepo, {:posts, args}, author)
      {:ok, posts}
    end)
  end
end

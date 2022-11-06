defmodule BlogoWeb.Graphql.Resolvers.Post do
  @moduledoc """
  Post graphql resolver
  """
  alias Blogo.{Author, Posts, Tag}
  alias Blogo.Repo.DataloaderRepo

  def get(_root, %{id: id}, _info) do
    case Posts.get(id) do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end

  def all(_root, _params, _info), do: {:ok, Posts.all()}

  def by_author(%Author{} = author, args, %{context: %{loader: loader}}),
    do: DataloaderRepo.by_parent(author, :posts, args, loader)

  def by_tag(%Tag{} = tag, args, %{context: %{loader: loader}}),
    do: DataloaderRepo.by_parent(tag, :posts, args, loader)
end

defmodule BlogoWeb.Graphql.Resolvers.Author do
  @moduledoc """
  Author graphql resolver
  """
  alias Blogo.{Authors, Post, Tag}
  alias Blogo.Repo.DataloaderRepo

  def get(_root, %{id: id}, _info) do
    case Authors.get(id) do
      nil -> {:error, "Author not found"}
      author -> {:ok, author}
    end
  end

  def all(_root, _params, _info), do: {:ok, Authors.all()}

  def by_post(%Post{} = post, args, %{context: %{loader: loader}}),
    do: DataloaderRepo.by_parent(post, :authors, args, loader)

  def by_tag(%Tag{} = tag, args, %{context: %{loader: loader}}),
    do: DataloaderRepo.by_parent(tag, :authors, args, loader)
end

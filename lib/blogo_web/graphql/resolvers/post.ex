defmodule BlogoWeb.Graphql.Resolvers.Post do
  @moduledoc """
  Post graphql resolver
  """
  alias Blogo.Posts

  def get(_root, %{id: id}, _info) do
    case Posts.get(id) do
      nil -> {:error, "Post not found"}
      post -> {:ok, post}
    end
  end

  def all(_root, _params, _info) do
    {:ok, Posts.all()}
  end
end

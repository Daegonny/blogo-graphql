defmodule BlogoWeb.Graphql.Resolvers.Tag do
  @moduledoc """
  Tag graphql resolver
  """
  alias Blogo.Tags

  def get(_root, %{id: id}, _info) do
    case Tags.get(id) do
      nil -> {:error, "Tag not found"}
      tag -> {:ok, tag}
    end
  end

  def all(_root, _params, _info) do
    {:ok, Tags.all()}
  end
end

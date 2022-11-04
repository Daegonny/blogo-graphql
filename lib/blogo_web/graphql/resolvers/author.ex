defmodule BlogoWeb.Graphql.Resolvers.Author do
  @moduledoc """
  Author graphql resolver
  """
  alias Blogo.Authors

  def get(_root, %{id: id}, _info) do
    case Authors.get(id) do
      nil -> {:error, "Author not found"}
      author -> {:ok, author}
    end
  end

  def all(_root, _params, _info) do
    {:ok, Authors.all()}
  end
end

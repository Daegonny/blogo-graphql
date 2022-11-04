defmodule BlogoWeb.Graphql.Resolvers.Hello do
  @moduledoc false
  def get_hello(_, _, _) do
    {:ok, "Hello World"}
  end
end

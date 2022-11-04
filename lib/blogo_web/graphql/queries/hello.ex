defmodule BlogoWeb.Graphql.Queries.Hello do
  @moduledoc false
  use Absinthe.Schema.Notation
  alias BlogoWeb.Graphql.Resolvers

  object :hello_queries do
    @desc "Hello World"
    field :hello, :string do
      resolve(&Resolvers.Hello.get_hello/3)
    end
  end
end

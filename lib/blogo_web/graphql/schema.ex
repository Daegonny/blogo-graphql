defmodule BlogoWeb.Graphql.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias BlogoWeb.Graphql.Queries

  def plugins do
    Absinthe.Plugin.defaults()
  end

  import_types(Queries.Hello)

  query do
    import_fields(:hello_queries)
  end
end

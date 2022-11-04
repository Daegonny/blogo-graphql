defmodule BlogoWeb.Graphql.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias BlogoWeb.Graphql.{Queries, Types}

  def plugins do
    Absinthe.Plugin.defaults()
  end

  import_types(Types.Tag)
  import_types(Queries.Hello)
  import_types(Queries.Tag)

  query do
    import_fields(:hello_queries)
    import_fields(:tag_queries)
  end
end

defmodule BlogoWeb.Graphql.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias BlogoWeb.Graphql.{Queries, Types}

  def plugins do
    Absinthe.Plugin.defaults()
  end

  import_types(Types.Tag)
  import_types(Queries.Tag)

  import_types(Types.Post)
  import_types(Queries.Post)

  query do
    import_fields(:tag_queries)
    import_fields(:post_queries)
  end
end

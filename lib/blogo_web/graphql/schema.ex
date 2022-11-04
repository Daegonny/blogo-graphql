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

  import_types(Types.Author)
  import_types(Queries.Author)

  query do
    import_fields(:tag_queries)
    import_fields(:post_queries)
    import_fields(:author_queries)
  end
end

defmodule BlogoWeb.Graphql.Schema do
  @moduledoc false
  use Absinthe.Schema
  alias Blogo.Repo.DataloaderRepo
  alias BlogoWeb.Graphql.{Queries, Types}
  alias BlogoWeb.Graphql.Middlewares.{DepthLimit, ErrorHandler, SafeResolution}

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader do
    Dataloader.new()
    |> Dataloader.add_source(DataloaderRepo, DataloaderRepo.data())
  end

  def context(ctx), do: Map.put(ctx, :loader, dataloader())

  import_types(Types.Tag)
  import_types(Queries.Tag)

  import_types(Types.Post)
  import_types(Queries.Post)

  import_types(Types.Author)
  import_types(Queries.Author)

  import_types(Types.Sorting)
  import_types(Types.Scalar.DateTime)
  import_types(Types.Scalar.UUID)

  query do
    import_fields(:tag_queries)
    import_fields(:post_queries)
    import_fields(:author_queries)
  end

  def middleware(middleware, _field, %{identifier: type}) when type in [:query, :mutation],
    do: [DepthLimit] ++ SafeResolution.apply(middleware) ++ [ErrorHandler]

  def middleware(middleware, _field, _object), do: middleware
end

defmodule BlogoWeb.Graphql.Middlewares.SafeResolution do
  @moduledoc """
  Absinthe middleware for safe resolution exceptions.
  More info at: https://shyr.io/blog/absinthe-exception-error-handling
  """

  alias Absinthe.Resolution
  require Logger

  @behaviour Absinthe.Middleware
  @default_error {:error, :unknown}

  @spec apply(list()) :: list()
  def apply(middleware) when is_list(middleware) do
    Enum.map(middleware, fn
      {{Resolution, :call}, resolver} -> {__MODULE__, resolver}
      other -> other
    end)
  end

  @impl true
  def call(resolution, resolver) do
    Resolution.call(resolution, resolver)
  rescue
    exception ->
      error = Exception.format(:error, exception, __STACKTRACE__)
      Logger.error(error)
      Resolution.put_result(resolution, @default_error)
  end
end

defmodule Blogo.Utils.Error do
  @moduledoc """
  Error standardization.
  More info at: https://shyr.io/blog/absinthe-exception-error-handling
  """

  require Logger
  alias __MODULE__

  defstruct [:code, :message, :status_code]

  def normalize({:error, reason}), do: handle(reason)

  def normalize({:error, _operation, reason, _changes}), do: handle(reason)

  def normalize(other), do: handle(other)

  defp handle(code) when is_atom(code) do
    {status, message} = metadata(code)

    %Error{
      code: code,
      message: message,
      status_code: status
    }
  end

  defp handle(errors) when is_list(errors), do: Enum.map(errors, &handle/1)

  defp handle(other) do
    Logger.error("Unhandled error term:\n#{inspect(other)}")
    handle(:unknown)
  end

  defp metadata(:invalid_argument), do: {400, "Invalid arguments passed"}
  defp metadata(:not_found), do: {404, "Resource not found"}
  defp metadata(:unknown), do: {500, "Something went wrong"}
end

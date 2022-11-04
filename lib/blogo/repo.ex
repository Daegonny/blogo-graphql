defmodule Blogo.Repo do
  use Ecto.Repo,
    otp_app: :blogo,
    adapter: Ecto.Adapters.Postgres
end

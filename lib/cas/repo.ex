defmodule Cas.Repo do
  use Ecto.Repo,
    otp_app: :cas,
    adapter: Ecto.Adapters.Postgres
end

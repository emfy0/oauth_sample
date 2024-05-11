defmodule BaseApp.Repo do
  use Ecto.Repo,
    otp_app: :base_app,
    adapter: Ecto.Adapters.SQLite3
end

defmodule AuthApp.Validators.Clients.CreateValidation do
  use Datacaster.Contract

  define_schema(:create) do
    hash_schema(
      name: non_empty_string(),
      callback_url: non_empty_string() > check("must be url", &(url?(&1)))
    )
  end

  def url?(url) do
    case URI.new(url) do
      {:ok, url} -> url.host && url.path
      _ -> false
    end
  end
end

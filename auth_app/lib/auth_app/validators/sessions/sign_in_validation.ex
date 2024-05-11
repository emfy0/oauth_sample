defmodule AuthApp.Validators.Sessions.SignInValidation do
  use Datacaster.Contract

  define_schema(:login) do
    hash_schema(
      email: non_empty_string() > check("must be email", &(Validation.email(&1))),
      password: non_empty_string() > check("length must be between 7 and 20", &(String.length(&1) in 7..20))
    )
  end
end

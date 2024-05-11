defmodule AuthAppWeb.SessionSignInLive do
  use AuthAppWeb, :live_view

  alias AuthApp.Validators.Sessions.SignInValidation

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :form, to_form(%{}, as: :user))}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    {_, params} =  SignInValidation.validate_to_changeset(:login, params)
    {:noreply, assign(socket, :form, to_form(params, as: :user))}
  end

  def render(assigns) do
    ~H"""
      <.simple_form for={@form} phx-change="validate" action={~p"/auth/sign_in"}>
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:password]} label="Password" />

        <:actions>
          <.button>Login</.button>
        </:actions>
      </.simple_form>

      <p class="mt-4 text-center text-sm text-gray-600">
        Don't have an account?

        <.link
          navigate={Helpers.session_sign_up_path(@socket, :new)}
          class="text-sm text-center text-blue-600 hover:underline"
          >
          Register
        </.link>
      </p>
    """
  end
end

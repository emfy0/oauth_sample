defmodule AuthAppWeb.Router do
  use AuthAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AuthAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AuthAppWeb do
    pipe_through :browser

    scope "/oauth" do
      get "/", OauthController, :show
      post "/", OauthController, :create_authorization
    end

    scope "/auth" do
      live_session :not_authenticated,
        on_mount: [
          {AuthAppWeb.UserAuth, :ensure_not_authenticated},
        ]
      do
        live "/sign_in", SessionSignInLive, :new
        live "/sign_up", SessionSignUpLive, :new
      end

      post "/sign_in", SessionController, :create
      delete "/sign_out", SessionController, :delete
    end

    live_session :ensure_current_user,
      on_mount: [
        {AuthAppWeb.UserAuth, :ensure_current_user},
      ]
    do
      scope "/users" do
        live "/me", UsersMeLive, :show
      end
    end
  end

  # Other scopes may use custom stacks.
  scope "/api", AuthAppWeb do
    pipe_through :api

    scope "/oauth" do
      get "/", ApiOauthController, :show
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:auth_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AuthAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

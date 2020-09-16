defmodule BankWeb.Router do
  use BankWeb, :router

  import BankWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [:json],
                       pass: ["application/json", "text/json"],
                       json_decoder: Jason

    plug :fetch_session
    plug :fetch_flash
    plug :fetch_current_user
  end

  # Other scopes may use custom stacks.
  # scope "/api", BankWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: BankWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", BankWeb do
    pipe_through [:browser]

    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
    get "/", HomeController, :index
  end

  scope "/", BankWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/v1/api", BankWeb do
    pipe_through [:api, :require_api_authentication]

    get "/users", UserController, :show
    get "/users/transactions", UserController, :show_transactions
    post "/deposits", DepositController, :create
    get "/deposits/:id", DepositController, :show
    get "/deposits", DepositController, :index
    post "/withdrawals", WithdrawalController, :create
    get "/withdrawals/:id", WithdrawalController, :show
    get "/withdrawals", WithdrawalController, :index
    post "/payments", PaymentController, :create
    get "/payments/:id", PaymentController, :show
    get "/payments", PaymentController, :index
  end

  scope "/v1/api", BankWeb do
    pipe_through [:api, :require_authenticated_user]

    get "/log_out", UserSessionController, :delete
  end

  scope "/app", BankWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/*app", AppController, :index
  end
end

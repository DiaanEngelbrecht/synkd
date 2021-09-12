defmodule SynkdWeb.OAuthController do
  use SynkdWeb, :controller

  alias Synkd.OAuth

  action_fallback(SynkdWeb.FallbackController)

  def generate_oauth_redirect_url(conn, %{"requested_provider" => requested_identity_provider}) do
    with {:ok, identity_provider} <-
           OAuth.get_valid_identity_provider(requested_identity_provider) do
      client_redirect_to = OAuth.get_authorization_url(identity_provider)

      conn
      |> put_status(200)
      |> json(%{redirect: client_redirect_to})
    end
  end

  def exchange_code_for_token(conn, %{"code" => temp_code, "state" => state}) do
    with {:ok, state_map} <- Jason.decode(state),
         {:ok, identity_provider} <- OAuth.get_valid_identity_provider(state_map["provider"]),
         {:ok, access_token} <- OAuth.swap_code_for_token(identity_provider, temp_code),
         {:ok, session} <- OAuth.create_session(identity_provider, access_token) do
      conn
      |> put_status(200)
      |> json(%{info: "Login successfull", session: %{id: session.id}})
    end
  end
end

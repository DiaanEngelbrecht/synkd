defmodule Synkd.OAuth do
  @moduledoc """
  The OAuth context.
  """

  @spotify_client_id Application.get_env(:synkd, :spotify)[:client_id]
  @spotify_base_url "https://accounts.spotify.com"
  @spotify_scopes "user-read-private user-read-email"

  @frontend_base_url Application.get_env(:synkd, :frontend_base_url)

  alias Synkd.Sessions.Session
  alias Synkd.Sessions.SessionAgent

  defp spotify_api(), do: Application.get_env(:synkd, :spotify)[:api]

  def get_valid_identity_provider(requested_provider) do
    case requested_provider do
      "spotify" ->
        {:ok, :spotify}

      _ ->
        {:ok, "The requested identity provider is not supported"}
    end
  end

  def get_authorization_url(provider) do
    state = %{'provider' => Atom.to_string(provider)} |> Jason.encode!()

    case provider do
      :spotify ->
        URI.encode(
          "#{@spotify_base_url}/authorize?client_id=#{@spotify_client_id}&response_type=code&redirect_uri=#{@frontend_base_url}/oauth/redirect&scope=#{@spotify_scopes}&state=#{state}"
        )
    end
  end

  def swap_code_for_token(provider, code) do
    case provider do
      :spotify ->
        spotify_api().request_token(code)
    end
  end

  def create_session(identity_provider, access_token) do
    session = %Session{
      id: Ecto.UUID.generate(),
      access_token: access_token,
      provider: identity_provider
    }

    with :ok <- SessionAgent.add(session) do
      {:ok, session}
    end
  end
end

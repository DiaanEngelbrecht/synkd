defmodule Synkd.OAuth.Spotify.API do
  @behaviour Synkd.OAuth.AuthorizationFlowBehaviour

  @spotify_client_id Application.get_env(:synkd, :spotify)[:client_id]
  @spotify_client_secret Application.get_env(:synkd, :spotify)[:client_secret]
  @spotify_base_url "https://accounts.spotify.com"

  @frontend_base_url Application.get_env(:synkd, :frontend_base_url)

  def request_token(code) do
    body =
      %{
        client_id: @spotify_client_id,
        client_secret: @spotify_client_secret,
        grant_type: "authorization_code",
        code: code,
        redirect_uri: "#{@frontend_base_url}/oauth/redirect"
      }
      |> URI.encode_query()

    url = "#{@spotify_base_url}/api/token"
    headers = %{"Content-Type" => "application/x-www-form-urlencoded"}
    {:ok, %HTTPoison.Response{} = response} = HTTPoison.post(url, body, headers)

    %{
      "access_token" => access_token,
      "token_type" => "Bearer",
      "scope" => _scopes,
      "expires_in" => _expires_in,
      "refresh_token" => _refresh_token
    } =
      response.body
      |> Jason.decode!()

    {:ok, access_token}
  end
end

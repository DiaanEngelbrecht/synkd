defmodule SynkdWeb.PageController do
  use SynkdWeb, :controller

  def index(conn, _params) do
    spotify_oauth_url = Synkd.OAuth.get_authorization_url(:spotify)
    render(conn, "index.html", spotify_oauth_url: spotify_oauth_url)
  end
end

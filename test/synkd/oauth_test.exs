defmodule Synkd.OAuthTest do
  use Synkd.DataCase

  describe "oauth" do
    alias Synkd.OAuth

    test "get_authorization_url/1 returns correct url for spotify" do
      assert "https://accounts.spotify.com/authorize?client_id=your-spotify-client-id&response_type=code&redirect_uri=http://azap.gamedate.co.za/oauth/redirect&scope=user-read-private%20user-read-email&state=%7B%22provider%22:%22spotify%22%7D" =
               OAuth.get_authorization_url(:spotify)
    end
  end
end

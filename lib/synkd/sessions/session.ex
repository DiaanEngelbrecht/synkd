defmodule Synkd.Sessions.Session do
  defstruct [:id, :access_token, :refresh_token, :provider]
end

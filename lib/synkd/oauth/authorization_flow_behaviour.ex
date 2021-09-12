defmodule Synkd.OAuth.AuthorizationFlowBehaviour do
  @callback request_token(binary()) :: {:ok, binary()}
end

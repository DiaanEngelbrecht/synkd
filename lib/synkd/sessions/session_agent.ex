defmodule Synkd.Sessions.SessionAgent do
  use Agent

  alias Synkd.Sessions.Session

  def start_link(_) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def get(id) do
    Agent.get(__MODULE__, &Enum.find(&1, fn session -> session.id == id end))
  end

  def add(%Session{} = new_session) do
    Agent.update(__MODULE__, fn sessions ->
      (sessions |> Enum.reject(fn session -> session.id == new_session.id end)) ++ [new_session]
    end)
  end
end

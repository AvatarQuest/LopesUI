defmodule LopesUI.ROS.Dashboard do
  use Agent

  def start_link(opts \\ []) do
    Agent.start_link(fn -> %{} end, name: __MODULE__, opts: opts)
  end

  def get(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def put(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

end

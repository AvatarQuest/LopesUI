defmodule LopesUI.ROS.Launch do
  use Agent

  def start_link(opts \\ {}) do
    Agent.start_link(fn -> %{arm: false, drivetrain: false, vision: false, audio: false} end, name: __MODULE__, opts: opts)
  end

  def start(key) do
    Agent.update(__MODULE__, &Map.put(&1, key, true))
  end

  def terminate(key) do
    Agent.update(__MODULE__, &Map.put(&1, key, false))
  end

  def is_on(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end
end

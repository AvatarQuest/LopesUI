defmodule LopesUI.ROS.Launch do
  use Agent

  def start_link(opts \\ {}) do
    Agent.start_link(fn -> %{arm: false, drivetrain: false, vision: false, audio: false, pids: []} end, name: __MODULE__, opts: opts)
  end

  def start(key) do
    Agent.update(__MODULE__, &Map.put(&1, key, true))
    for pid <- LopesUI.ROS.Launch.get_registered(), do: Process.send(pid, {key, true}, [])
  end

  def terminate(key) do
    for pid <- LopesUI.ROS.Launch.get_registered(), do: Process.send(pid, {key, false}, [])
    Agent.update(__MODULE__, &Map.put(&1, key, false))
  end

  def is_on(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def register(pid) do
    Agent.update(__MODULE__, &Map.put(&1, :pids, [pid | Map.get(&1, :pids)]))
  end

  def get_registered() do
    Agent.get(__MODULE__, &Map.get(&1, :pids))
  end

  def unregister(pid) do
    Agent.update(__MODULE__, &Map.put(&1, :pids, Map.get(&1, :pids) |> List.delete(pid)))
  end
end

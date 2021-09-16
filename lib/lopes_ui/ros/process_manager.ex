defmodule LopesUI.ROS.ProcessManager do
  use GenServer

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, state, name: ProcessManager)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def terminate_process(name) do
    GenServer.cast(ProcessManager, {:close, name})
  end

  def start_process(command) do
    GenServer.cast(ProcessManager, {:start, command})
  end

  def get_logs(name) do
    GenServer.call(ProcessManager, {:logs, name})
  end

  def delete(name) do
    GenServer.cast(ProcessManaget, {:delete, name})
  end
  def get_state do
    GenServer.call(ProcessManager, {:state})
  end

  @impl true
  def handle_cast({:delete, name}, state) do
    state = if Map.has_key?(state, name), do: Map.delete(state, name), else: state
    {:noreply, state}
  end

  @impl true
  def handle_cast({:start, %{cmd: cmd, args: args, name: name}}, state) do
    port = Port.open({:spawn_executable, cmd}, [:binary, :exit_status, {:args, args}])
    state = Map.put(state, name, %{port: port, logs: ""})

    LopesUI.ROS.Launch.start(name)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:close, name} , state) do
    IO.puts "#{inspect Map.get(state, name)}"
    %{port: port} = Map.get(state, name)
    if not is_nil(port) do
      pid = Port.info(port) |> Keyword.get(:os_pid)
      IO.inspect pid
      Port.close(port)
      System.cmd("kill", ["-9", "#{pid}"])
    end

    LopesUI.ROS.Launch.terminate(name)
    {:noreply, Map.delete(state, name)}
  end
  # /Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd

  @impl true
  def handle_info({port, {:data, msg}}, state) do
    atom = get_atom_by_port(state, port)
    state = Map.update!(state, atom, fn value -> Map.update!(value, :logs, fn logs -> logs <> "\n" <> msg end) end)
    {:noreply, state}
  end

  @impl true
  def handle_info({port, {:exit_status, msg}}, state) do
    IO.puts "Port #{inspect port} exited with status: #{msg}"
    atom = get_atom_by_port(state, port)
    state = Map.update!(state, atom, fn value -> Map.update!(value, :logs, fn logs -> logs <> "\n\n" <> "PROCESS DIED" end) |> Map.update!(:port, fn _ -> nil end) end)

    LopesUI.ROS.Launch.terminate(atom)
    {:noreply, state}
  end

  @impl true
  def handle_call({:state}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:logs, name}, _from, state) do
    {:reply, Map.get(state, name) |> Map.get(:logs), state}
  end

  def get_atom_by_port(state, port) do
    tuple = Enum.find(state, fn {_k, v} -> v.port == port end)
    if is_nil(tuple), do: nil, else: tuple |> Tuple.to_list() |> Enum.at(0)
  end
end

# alias LopesUI.ROS.ProcessManager
# ProcessManager.start_link
# LopesUI.ROS.ProcessManager.start_process(%{cmd: '/Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd', args: [], name: :scrapy})
# LopesUI.ROS.ProcessManager.terminate_process(:scrapy)

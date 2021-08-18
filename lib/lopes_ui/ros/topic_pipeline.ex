defmodule LopesUI.ROS.TopicPipeline do
  use GenServer

  @type sub :: %LopesUI.ROS.Topic.Subscriber{name: String, type: String}

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state,  name: TopicPipeline)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  # @spec handle_cast({:subscribe, sub}, Enum) :: {:noreply, Enum}
  def handle_cast({:subscribe, topic}, state) do
    IO.puts "Subscribing: #{inspect topic}"
    LopesUI.ROS.Rosbridge.send_json(%{"op" =>  "subscribe", "topic" => topic.name, "type" => topic.type})
    {:noreply, [topic | state]}
  end

  def handle_cast({:value, topic}, state) do
    wanted_topics = Enum.filter(state, &(&1.name == Map.get(topic, "topic")))
    Process.send(List.first(wanted_topics).pid, {:update, topic}, [])
    {:noreply, state}
  end

  @impl true
  def handle_cast({:unsubscribe, pid}, state) do
    removed_topic = Enum.find(state, &(&1.pid == pid))
    IO.puts "Unsubscribing: #{inspect removed_topic}"
    LopesUI.ROS.Rosbridge.send_json(%{"op" =>  "unsubscribe", "topic" => removed_topic.name, "type" => removed_topic.type})
    {:noreply, List.delete(state, removed_topic)}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def subscribe(topic) do
    GenServer.cast(TopicPipeline, {:subscribe, topic})
  end

  def unsubscribe(pid) do
    GenServer.cast(TopicPipeline, {:unsubscribe, pid})
  end

  def list do
    GenServer.call(TopicPipeline, :list)
  end

end

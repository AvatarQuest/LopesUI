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
    IO.inspect topic
    LopesUI.ROS.Rosbridge.send_json(%{"op" =>  "subscribe", "topic" => topic.name, "type" => topic.type})
    IO.puts "Sent websocket command"
    {:noreply, [topic | state]}
  end

  @impl true
  def handle_cast({:remove, topic}, state) do
    {:noreply, Enum.filter(state, fn x -> x != topic end)}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  def subscribe(topic) do
    IO.inspect topic
    GenServer.cast(TopicPipeline, {:subscribe, topic})
  end

  def list do
    GenServer.call(TopicPipeline, :list)
  end

end

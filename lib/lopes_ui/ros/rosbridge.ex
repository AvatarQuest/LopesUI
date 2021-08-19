defmodule LopesUI.ROS.Rosbridge do
  use WebSockex

  def start_link(url \\ "ws://0.0.0.0:9090", state) do
    WebSockex.start_link(url, __MODULE__, state, name: Rosbridge)
  end

  def handle_frame({type, msg}, state) do
    IO.puts "Received Message - Type: #{inspect type} -- Message: #{inspect msg}"
    GenServer.cast(TopicPipeline, {:value, msg |> Jason.decode!})
    {:ok, state}
  end

  def handle_cast({:send, {type, msg} = frame}, state) do
    IO.puts "Sending #{type} frame with payload: #{msg}"
    {:reply, frame, state}
  end

  def send_json(json) do
    WebSockex.cast(Rosbridge, {:send, {:text, Jason.encode!(json)}})
  end
end

# WebSockex.cast("Rosbridge", {:send, {:json, %{"op" =>  "subscriber", "topic" => "/test", "type" => "std_msgs/Int32"}}})
# roslaunch rosbridge_server rosbridge_websocket.launch _port:=9090 websocket_external_port:=80 --screen

defmodule LopesUIWeb.HomePage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("home_page.html", assigns)
  end

  def handle_event("listtopics", _value, socket) do
    [topic | _] = LopesUI.ROS.TopicPipeline.list
    {:noreply, assign(socket, progress: topic.name)}
  end

  def handle_info({:update, topic}, socket) do
    # IO.puts "UPDATING RN"
    # IO.inspect topic |> Map.get("msg") |> Map.get("data")
    # {:ok, temperature} = Thermostat.get_reading(socket.assigns.user_id)
    {:noreply, assign(socket, :progress, "#{topic |> Map.get("msg") |> Map.get("data")}")}
  end

  def terminate(reason, socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
  end

  def handle_event("validate", %{"user" => params}, socket) do
    {:noreply, socket}
  end

  def handle_event("subscribe", %{"user" => %{"topic" => topic, "type" => type}}, socket) do
    IO.puts "fsdhjafhjksdhkj"
    LopesUI.ROS.TopicPipeline.subscribe(%{name: topic, type: type, pid: self()})
    {:noreply, assign(socket, :topic_name, topic)}
  end

  def mount(_params, _session, socket) do
    LopesUI.ROS.TopicPipeline.subscribe(%{name: "/set_speed", type: "std_msgs/Int32", pid: self()})
    {:ok, assign(socket, progress: "Waiting for message...", topic_name: "/set_speed")}
  end
end

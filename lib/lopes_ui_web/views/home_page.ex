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
    {:noreply, assign(socket, :value, "#{topic |> Map.get("msg") |> Map.get("data")}")}
  end

  def terminate(_reason, _socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
  end

  def handle_event("validate", %{"form" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_event("subscribe", %{"form" => %{"topic" => topic, "type" => type}}, socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
    LopesUI.ROS.TopicPipeline.subscribe(%{name: topic, type: type, pid: self()})
    {:noreply, assign(socket, topic_name: topic, value: "Waiting for message...")}
  end

  def mount(_params, _session, socket) do
    LopesUI.ROS.TopicPipeline.subscribe(%{name: "/set_speed", type: "std_msgs/Int32", pid: self()})
    LopesUI.ROS.TopicPipeline.advertise(%{name: "/test", type: "std_msgs/Int32", pid: self()})
    {:ok, assign(socket, value: "Waiting for message...", topic_name: "/set_speed")}
  end
end

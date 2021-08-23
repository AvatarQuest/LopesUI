defmodule LopesUIWeb.HomePage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("dashboard_page.html", assigns)
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
    {:noreply, assign(socket, subscribe_topic: topic, value: "Waiting...")}
  end

  def handle_event("publish", %{"form" => %{"topic" => topic, "value" => value}}, socket) do
    LopesUI.ROS.TopicPipeline.advertise(%{name: topic, type: "std_msgs/Int32", pid: self()})
    {data, _} = Integer.parse(value)
    LopesUI.ROS.TopicPipeline.publish(%{name: topic, type: "std_msgs/Int32", msg: %{"data" => data}})
    {:noreply, assign(socket, publish_topic: topic)}
  end
  def mount(_params, _session, socket) do
    publish_name = "/test"
    subscribe_topic = "/test"
    LopesUI.ROS.TopicPipeline.subscribe(%{name: subscribe_topic, type: "std_msgs/Int32", pid: self()})
    LopesUI.ROS.TopicPipeline.advertise(%{name: publish_name, type: "std_msgs/Int32", pid: self()})
    {:ok, assign(socket, publish_topic: publish_name, value: "Waiting...", subscribe_topic: subscribe_topic, type: "std_msgs/Int32")}
  end
end

defmodule LopesUIWeb.HomePage do
  alias LopesUI.ROS.Topic
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("dashboard_page.html", assigns)
  end

  def handle_event("listtopics", _value, socket) do
    [topic | _] = LopesUI.ROS.TopicPipeline.list
    {:noreply, assign(socket, progress: topic.name)}
  end

  def handle_info({:update, topic}, socket) do
    data = topic |> Map.get("msg") |> Map.get("data")
    %{"topic" => topic} = topic

    changes = []
    changes = if (LopesUI.ROS.Dashboard.get(:card1)[:topic1] == topic), do: changes ++ [v1: "#{data}"], else: changes
    changes = if (LopesUI.ROS.Dashboard.get(:card2)[:topic2] == topic), do: changes ++ [v2: "#{data}"], else: changes
    changes = if (LopesUI.ROS.Dashboard.get(:card3)[:topic3] == topic), do: changes ++ [v3: "#{data}"], else: changes
    changes = if (LopesUI.ROS.Dashboard.get(:card4)[:topic4] == topic), do: changes ++ [v4: "#{data}"], else: changes
    changes = if (LopesUI.ROS.Dashboard.get(:card5)[:topic5] == topic), do: changes ++ [v5: "#{data}"], else: changes
    changes = if (LopesUI.ROS.Dashboard.get(:card6)[:topic6] == topic), do: changes ++ [v6: "#{data}"], else: changes

    {:noreply, assign(socket, changes)}
  end

  def terminate(_reason, _socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
  end

  def handle_event("validate", %{"form" => _params}, socket) do
    {:noreply, socket}
  end

  def handle_event("subscribe", %{"form" => %{"topic" => topic, "type" => type}}, socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: topic, type: type, pid: self()})
    {:noreply, assign(socket, subscribe_topic: topic, value: "Waiting...")}
  end

  def handle_event("publish", %{"form" => %{"topic" => topic, "value" => value}}, socket) do
    LopesUI.ROS.TopicPipeline.advertise(%Topic.Subscribe{name: topic, type: "std_msgs/Int32", pid: self()})
    {data, _} = Integer.parse(value)
    LopesUI.ROS.TopicPipeline.publish(%Topic.Publish{name: topic, type: "std_msgs/Int32", msg: %{"data" => data}})
    {:noreply, assign(socket, publish_topic: topic)}
  end

  def mount(_params, _session, socket) do
    opts1 = [topic1: "/set_topic", v1: "Waiting...", type1: "std_msgs/Int32", action1: "subscribe"]
    opts2 = [topic2: "/set_topic", v2: "Waiting...", type2: "std_msgs/Int32", action2: "subscribe"]
    opts3 = [topic3: "/set_topic", v3: "Waiting...", type3: "std_msgs/Int32", action3: "subscribe"]
    opts4 = [topic4: "/set_topic", v4: "Waiting...", type4: "std_msgs/Int32", action4: "subscribe"]
    opts5 = [topic5: "/set_topic", v5: "Waiting...", type5: "std_msgs/Int32", action5: "subscribe"]
    opts6 = [topic6: "/set_topic", v6: "Waiting...", type6: "std_msgs/Int32", action6: "subscribe"]

    LopesUI.ROS.Dashboard.put(:card1, opts1)
    LopesUI.ROS.Dashboard.put(:card2, opts2)
    LopesUI.ROS.Dashboard.put(:card3, opts3)
    LopesUI.ROS.Dashboard.put(:card4, opts4)
    LopesUI.ROS.Dashboard.put(:card5, opts5)

    opts = opts1 ++ opts2 ++ opts3 ++ opts4 ++ opts5 ++ opts6
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts1[:topic1], type: opts1[:type1], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts2[:topic2], type: opts2[:type2], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts3[:topic3], type: opts3[:type3], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts4[:topic4], type: opts4[:type4], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts5[:topic5], type: opts5[:type5], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts6[:topic6], type: opts6[:type6], pid: self()})

    {:ok, assign(socket, opts)}
  end

  def activate_card() do

  end

end

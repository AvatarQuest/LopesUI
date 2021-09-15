defmodule LopesUIWeb.HomePage do
  alias LopesUI.ROS.Topic
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("dashboard_page.html", assigns)
  end

  def convert_msg(msg) do
    msg |> Map.keys() |> Enum.map(fn key -> "#{key}: #{msg[key]}" end) |> Enum.join(",")
  end
  def handle_info({:update, topic}, socket) do
    msg = topic |> Map.get("msg")
    data = convert_msg(msg)
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

  def handle_event("publish1", %{"form" => %{"value" => value}}, socket) do
    card = LopesUI.ROS.Dashboard.get(:card1)
    IO.inspect(value)
    msg = value
    msg = if String.contains?(card[:type1], "std_msgs"), do: %{"data" => value}, else: msg
    msg = if String.contains?(card[:type1], "std_msgs/Int"), do: %{"data" => String.to_integer(value)}, else: msg
    msg = if String.contains?(card[:type1], "std_msgs/Float"), do: %{"data" => String.to_float(value)}, else: msg
    msg = if String.contains?(card[:type1], "geometry_msgs/Vector3"), do: %{"x" => String.split(value, ",")[0] |> String.to_float, "y" => String.split(value, ",")[1] |> String.to_float, "z" => String.split(value, ",")[2] |> String.to_float}, else: msg
    IO.inspect(msg)
    LopesUI.ROS.TopicPipeline.advertise(%Topic.Subscribe{name: card[:topic1], type: card[:type1], pid: self()})
    LopesUI.ROS.TopicPipeline.publish(%Topic.Publish{name: card[:topic1], type: card[:type1], msg: msg})
    {:noreply, socket}
  end

  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("subscribe", %{"form" => %{"topic" => topic, "type" => type}}, socket) do
    LopesUI.ROS.TopicPipeline.unsubscribe(self())
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: topic, type: type, pid: self()})
    {:noreply, assign(socket, subscribe_topic: topic, value: "Waiting...")}
  end

  def mount(_params, _session, socket) do
    opts1 = [topic1: "/thumb_middle", v1: "Waiting...", type1: "geometry_msgs/Vector3" , action1: "subscribe"]
    opts2 = [topic2: "/thumb_middle", v2: "Waiting...", type2: "geometry_msgs/Vector3", action2: "subscribe"]
    opts3 = [topic3: "/test", v3: "Waiting...", type3: "std_msgs/Int32", action3: "subscribe"]
    opts4 = [topic4: "/pinky", v4: "Waiting...", type4: "std_msgs/Float64", action4: "subscribe"]
    opts5 = [topic5: "/thumb", v5: "Waiting...", type5: "std_msgs/Float64", action5: "subscribe"]
    opts6 = [topic6: "/claw_angle", v6: "Waiting...", type6: "std_msgs/Float64", action6: "subscribe"]

    LopesUI.ROS.Dashboard.put(:card1, opts1)
    LopesUI.ROS.Dashboard.put(:card2, opts2)
    LopesUI.ROS.Dashboard.put(:card3, opts3)
    LopesUI.ROS.Dashboard.put(:card4, opts4)
    LopesUI.ROS.Dashboard.put(:card5, opts5)
    LopesUI.ROS.Dashboard.put(:card6, opts6)

    opts = opts1 ++ opts2 ++ opts3 ++ opts4 ++ opts5 ++ opts6
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts1[:topic1], type: opts1[:type1], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts2[:topic2], type: opts2[:type2], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts3[:topic3], type: opts3[:type3], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts4[:topic4], type: opts4[:type4], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts5[:topic5], type: opts5[:type5], pid: self()})
    LopesUI.ROS.TopicPipeline.subscribe(%Topic.Subscribe{name: opts6[:topic6], type: opts6[:type6], pid: self()})

    {:ok, assign(socket, opts)}
  end

end

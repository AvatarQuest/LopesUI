defmodule LopesUIWeb.HomePage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("home_page.html", assigns)
  end

  def handle_event("github_deploy", _value, socket) do
    [topic | _] = LopesUI.ROS.TopicPipeline.list
    {:noreply, assign(socket, progress: topic.name)}
  end

  def mount(_params, _session, socket) do
    LopesUI.ROS.TopicPipeline.subscribe(%{name: "/test", type: "std_msgs/Int32"})
    {:ok, assign(socket, progress: "Ready!")}
  end
end

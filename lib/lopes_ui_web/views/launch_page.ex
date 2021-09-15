defmodule LopesUIWeb.LaunchPage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("launch_page.html", assigns)
  end

  def handle_event("arm", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:arm) do
      :os.cmd('roslaunch arm arm.launch')
      LopesUI.ROS.Launch.start(:arm)
    end
    IO.puts "arm"
    {:noreply, socket}
  end

  def handle_event("drivetrain", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:drivetrain) do
      :os.cmd('roslaunch drivetrain drivetrain.launch')
      LopesUI.ROS.Launch.start(:drivetrain)
    end
    IO.puts "drivetrain"
    {:noreply, socket}
  end

  def handle_event("vision", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:vision) do
      :os.cmd('roslaunch vision vision.launch')
      LopesUI.ROS.Launch.start(:vision)
    end
    IO.puts "vision"
    {:noreply, socket}
  end

  def handle_event("audio", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:audio) do
      # :os.cmd('roslaunch drivetrain drivetrain.launch')
      LopesUI.ROS.Launch.start(:audio)
    end
    IO.puts "audio"
    {:noreply, socket}
  end
end

defmodule LopesUIWeb.LaunchPage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("launch_page.html", assigns)
  end

  def mount(_params, _session, socket) do
    arm_status = if LopesUI.ROS.Launch.is_on(:arm), do: "Started", else: "Not Started"
    drivetrain_status = if LopesUI.ROS.Launch.is_on(:drivetrain), do: "Started", else: "Not Started"
    vision_status = if LopesUI.ROS.Launch.is_on(:vision), do: "Started", else: "Not Started"
    audio_status = if LopesUI.ROS.Launch.is_on(:audio), do: "Started", else: "Not Started"

    LopesUI.ROS.Launch.register(self())
    {:ok, assign(socket, arm_status: arm_status, drivetrain_status: drivetrain_status, vision_status: vision_status, audio_status: audio_status)}
  end

  def handle_info({:arm, update}, socket) do
    msg = if update, do: "Started", else: "Not started"
    {:noreply, assign(socket, arm_status: msg)}
  end

  def handle_info({:drivetrain, update}, socket) do
    msg = if update, do: "Started", else: "Not started"
    {:noreply, assign(socket, drivetrain_status: msg)}
  end

  def handle_info({:vision, update}, socket) do
    msg = if update, do: "Started", else: "Not started"
    {:noreply, assign(socket, vision_status: msg)}
  end

  def handle_info({:audio, update}, socket) do
    msg = if update, do: "Started", else: "Not started"
    {:noreply, assign(socket, audio_status: msg)}
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

  def terminate(_reason, _socket) do
    LopesUI.ROS.Launch.unregister(self())
  end
end

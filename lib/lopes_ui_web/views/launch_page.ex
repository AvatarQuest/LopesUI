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
      LopesUI.ROS.ProcessManager.start_process(%{name: :arm, cmd: "/Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd", args: []})
      # LopesUI.ROS.ProcessManager.start_process(%{name: :arm, cmd: "roslaunch", args: ["arm", "arm.launch"]})
    else
      LopesUI.ROS.ProcessManager.terminate_process(:arm)
    end
    IO.puts "arm"
    {:noreply, socket}
  end

  def handle_event("drivetrain", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:drivetrain) do
      LopesUI.ROS.ProcessManager.start_process(%{name: :drivetrain, cmd: "/Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd", args: []})
      # LopesUI.ROS.ProcessManager.start_process(%{name: :drivetrain, cmd: "roslaunch", args: ["drivetrain", "arm.launch"]})
    else
      LopesUI.ROS.ProcessManager.terminate_process(:drivetrain)
    end
    IO.puts "drivetrain"
    {:noreply, socket}
  end

  def handle_event("vision", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:vision) do
      LopesUI.ROS.ProcessManager.start_process(%{name: :vision, cmd: "/Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd", args: []})
      # LopesUI.ROS.ProcessManager.start_process(%{name: :vision, cmd: "roslaunch", args: ["vision", "vision.launch"]})
    else
      LopesUI.ROS.ProcessManager.terminate_process(:vision)
    end
    IO.puts "vision"
    {:noreply, socket}
  end

  def handle_event("audio", _unsigned_params, socket) do
    if not LopesUI.ROS.Launch.is_on(:audio) do
      LopesUI.ROS.ProcessManager.start_process(%{name: :audio, cmd: "/Users/adityapawar/Documents/GitHub/A1S_App/env/bin/scrapyd", args: []})
      # LopesUI.ROS.ProcessManager.start_process(%{name: :audio, cmd: "roslaunch", args: ["audio", "audio.launch"]})
    else
      LopesUI.ROS.ProcessManager.terminate_process(:audio)
    end
    IO.puts "audio"
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
    LopesUI.ROS.Launch.unregister(self())
  end
end

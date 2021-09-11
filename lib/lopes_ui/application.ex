defmodule LopesUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LopesUiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LopesUi.PubSub},
      # Start the Endpoint (http/https)
      LopesUiWeb.Endpoint,
      # Start a worker by calling: LopesUi.Worker.start_link(arg)
      LopesUI.ROS.TopicPipeline,
      LopesUI.ROS.Dashboard,
      {LopesUI.ROS.Rosbridge, "ws://localhost:9090"}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LopesUi.Supervisor]
    Supervisor.start_link(children, opts)
  end
  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LopesUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
#  sub = %Subscriber{name: "/test", type: "std_msgs/Int32"}
# alias LopesUI.ROS.Topic.Subscriber
#  GenServer.cast(LopesUI.ROS.TopicPipeline, {:subscribe, sub})

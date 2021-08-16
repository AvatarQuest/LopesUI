defmodule LopesUI.ROS.Topic.Subscriber do
  # use GenServer

  @enforce_keys [:name, :type]
  defstruct [:name, :type]

  def init() do
    {:ok, []}
  end

end

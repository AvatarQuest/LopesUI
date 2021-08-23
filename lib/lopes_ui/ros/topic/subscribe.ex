defmodule LopesUI.ROS.Topic.Subscribe do
  @enforce_keys [:name, :type]
  defstruct [:name, :type, :pid]
end

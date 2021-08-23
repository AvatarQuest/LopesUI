defmodule LopesUI.ROS.Topic.Publish do
  @enforce_keys [:name, :type, :msg]
  defstruct [:name, :type, :msg, :pid]
end

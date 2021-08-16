defmodule LopesUi.ROS.Sub do
  use ROS

#   callback = fn %StdMsgs.String{data: data} ->
#     IO.puts(data)
#   end

#   children = [
#     node(:"/mynode", [
#       subscriber("chatter", "std_msgs/String", callback)
#     ])
#   ]

#   Supervisor.start_link(children, strategy: :one_for_one)
end

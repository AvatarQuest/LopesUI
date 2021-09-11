defmodule LopesUiWeb.LaunchController do
  use LopesUiWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, LopesUIWeb.LaunchPage, session: %{})
  end
end

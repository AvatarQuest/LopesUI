defmodule LopesUiWeb.HomeController do
  use LopesUiWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, LopesUIWeb.HomePage, session: %{})
  end
end

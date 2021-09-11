defmodule LopesUIWeb.LaunchPage do
  use Phoenix.LiveView

  def render(assigns) do
    LopesUiWeb.PageView.render("launch_page.html", assigns)
  end
end

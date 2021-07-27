defmodule LopesUiWeb.PageController do
  use LopesUiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule SynkdWeb.PageControllerTest do
  use SynkdWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Synkd"
  end
end

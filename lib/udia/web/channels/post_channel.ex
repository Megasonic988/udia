defmodule Udia.Web.PostChannel do
  @moduledoc """
  Post websocket implementation.
  """
  use Udia.Web, :channel

  def join("post:" <> post_id, params, socket) do
    {:ok, assign(socket, :post_id, post_id)}
  end
end

defmodule NoozoWeb.Cvs.ShowView do
  use Phoenix.LiveView

  alias Noozo.Cvs

  alias NoozoWeb.Admin.Cvs.Children.PreviewView, as: Preview

  def render(assigns) do
    ~L"""
      <%= live_render @socket, Preview, id: :preview, session: %{"cv_uuid" => @cv.uuid} %>
    """
  end

  def handle_params(%{"user_id" => user_id} = _params, _uri, socket) do
    cv = Cvs.get_user_cv!(user_id)
    {:noreply, assign(socket, :cv, cv)}
  end
end

defmodule NoozoWeb.Admin.Cvs.Children.Components.SectionItems do
  @moduledoc """
  Section items component
  """
  use Phoenix.LiveComponent

  alias Noozo.Cvs

  alias NoozoWeb.Admin.Cvs.Children.SectionItemView

  require Logger

  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="mt-6">
      <div class="text-lg mb-4 cursor-pointer">
        Items
      </div>

      <a class="btn cursor-pointer" phx-click="add-item" phx-target="<%= @myself %>">
        Add Item
      </a>

      <div class="mt-6">
        <%= for item <- @items do %>
          <div class="flex">
            <%= live_render @socket, SectionItemView, id: "section_item_#{item.uuid}", session: %{"item_uuid" => item.uuid} %>
            <a class="btn cursor-pointer flex-col h-10"
                  phx-click="remove-item" phx-target="<%= @myself %>" phx-value-item_uuid="<%= item.uuid %>">X</a>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def update(%{id: id, section_uuid: section_uuid} = _assigns, socket) do
    section = Cvs.get_section!(section_uuid)
    {:ok, assign(socket, %{id: id, items: section.items, section_uuid: section_uuid})}
  end

  def handle_event("add-item", _event, socket) do
    {:ok, item} = Cvs.create_section_item(socket.assigns.section_uuid)
    {:noreply, assign(socket, :items, socket.assigns.items ++ [item])}
  end

  def handle_event("remove-item", %{"item_uuid" => item_uuid} = _event, socket) do
    {:ok, _item} = Cvs.delete_section_item(item_uuid)
    items = Enum.reject(socket.assigns.items, &(&1.uuid == item_uuid))
    {:noreply, assign(socket, :items, items)}
  end

  def handle_info({event, _cv}, socket) do
    Logger.debug("SectionItems - Unhandled event: #{event}")
    {:noreply, socket}
  end
end

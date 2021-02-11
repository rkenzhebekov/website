defmodule NoozoWeb.Admin.Cvs.Children.HeaderItemsView do
  use Phoenix.LiveView

  alias Noozo.Cvs

  alias NoozoWeb.Admin.Cvs.Children.Components.{ExpandCollapse, HeaderItem}

  require Logger

  def render(assigns) do
    ~L"""
    <div class="mt-6" x-data="{collapsed: true}">
      <div class="text-lg mb-4 cursor-pointer" @click="collapsed = !collapsed">
        <%= live_component @socket, ExpandCollapse, var: "collapsed" %>
        Header Items
      </div>

      <a class="btn cursor-pointer mb-6" phx-click="add-item"
         :class="{'hidden': collapsed, 'visible': !collapsed}">
        Add Header Item
      </a>

      <div class="mt-6" :class="{'hidden': collapsed, 'visible': !collapsed}">
        <%= for item <- @items do %>
          <div class="flex">
            <div class="flex-col">
              <%= live_component @socket, HeaderItem, id: "header_item_#{item.uuid}", item: item %>
            </div>
            <a class="btn cursor-pointer flex-col h-10"
               phx-click="remove-item"
               phx-value-item_uuid="<%= item.uuid %>">X</a>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, %{"cv_uuid" => cv_uuid} = _session, socket) do
    Cvs.subscribe()
    items = Cvs.get_header_items!(cv_uuid)
    {:ok, assign(socket, %{cv_uuid: cv_uuid, items: items})}
  end

  def handle_event("add-item", _event, socket) do
    {:ok, item} = Cvs.create_header_item(socket.assigns.cv_uuid)
    {:noreply, assign(socket, :items, socket.assigns.items ++ [item])}
  end

  def handle_event("remove-item", %{"item_uuid" => item_uuid} = _event, socket) do
    {:ok, _item} = Cvs.delete_header_item(item_uuid)
    items = Enum.reject(socket.assigns.items, &(&1.uuid == item_uuid))
    {:noreply, assign(socket, :items, items)}
  end

  def handle_info({event, _cv}, socket) do
    Logger.debug("HeaderItemsView - Unhandled event: #{event}")
    {:noreply, socket}
  end
end
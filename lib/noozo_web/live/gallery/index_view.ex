defmodule NoozoWeb.Gallery.IndexView do
  use Phoenix.LiveView

  import Noozo.Pagination

  alias Noozo.Gallery
  alias Noozo.Gallery.Image

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    Gallery.subscribe()
    params = Map.put(params, "page_size", 8)
    images = Gallery.list(params)
    {:noreply, assign(socket, images: images, params: params)}
  end

  def handle_info({_event, _item}, socket) do
    images = Gallery.list(socket.assigns.params)
    {:noreply, assign(socket, :images, images)}
  end

  def render(assigns) do
    ~L"""
    <h1 class="text-2xl font-bold">Some of my doings in the workshop</h1>
    <div class="w-full flex flex-row flex-wrap gap-6 mx-auto p-8">
      <%= for image <- @images do %>
        <div class="w-60 h-auto bg-white rounded shadow-md" x-data="{open: false}">
          <div class="cursor-pointer text-grey-darkest no-underline" x-on:click.prevent="open = true">
              <h1 class="text-xl p-6"><%= image.title %>.</h1>
              <%= if image.image do %>
                <div class="align-bottom">
                  <img alt="<%= image.title %>" class="w-60" src="<%= Image.image_url(image) %>" />
                </div>
              <% end %>
          </div>

          <div x-show.transition.opacity="open" x-on:click.away="open = false"
               class="p-4 hidden flex justify-center items-center inset-0 bg-black bg-opacity-75 z-50"
               :class="{'fixed': open, 'hidden': !open}">
            <div x-show.transition="open"
              class="container max-w-3xl max-h-full bg-white rounded-xl shadow-lg overflow-auto">
              <div class="px-8 py-4 border-b border-gray-200">
                <h2><%= image.title %>.</h2>
              </div>
              <div class="px-8 py-4">
                <img alt="<%= image.title %>" class="w-full" src="<%= Image.image_url(image) %>" />
              </div>
              <div class="px-8 py-4 border-t border-gray-200 text-center">
                <button x-on:click.prevent="open = false"
                        class="py-2 px-4 rounded-full text-center inline-block border border-gray-200 text-black bg-white hover:bg-black hover:text-white focus:outline-none">
                  Close
                </button>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    <%= live_paginate(assigns, @images, __MODULE__, @socket) %>
    """
  end
end

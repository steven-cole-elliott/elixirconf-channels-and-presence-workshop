defmodule SketchpadWeb.PadChannelTest do
  use SketchpadWeb.ChannelCase

  describe "after join" do
    setup do
      {:ok, _, socket} =
        socket(nil, %{some_assigns: 1})
        |> Phoenix.Socket.assign(:user_id, "123")
        |> subscribe_and_join(SketchpadWeb.PadChannel, "pad:lobby", %{})

      {:ok, socket: socket}
    end

    test "presence list is sent on join" do
      assert_push "presence_state", %{}
      assert_broadcast "presence_diff", %{joins: %{"123" => _}}
    end

    test "pushing clear event broadcasts to all peers", %{socket: socket} do
      ref = push socket, "clear", %{}
      assert_reply ref, :ok

      assert_broadcast "clear", %{}
    end
  end

  alias SketchpadWeb.UserSocket
  describe "connecting and joining" do

    test "invalid tokens deny connection" do
      assert :error = connect(UserSocket, %{"token" => "invalid"})
    end

    test "valid tokens verify and connect user" do
      # @endpoint comes from our ChannelCase
      valid_token = Phoenix.Token.sign(@endpoint, "user token", "a-user")
      assert {:ok, socket} = connect(UserSocket, %{"token" => valid_token})
      assert socket.assigns.user_id == "a-user"
    end
  end
end

defmodule ElixirInterviewStarter.DeviceMessages do
  @moduledoc """
  You shouldn't need to mofidy this module.

  This module provides an interface for mock-sending commands to devices.
  """

  @spec send(user_email :: String.t(), command :: String.t(), pid :: pid()) :: :ok
  @doc """
  Pretends to send the provided command to the Sutro Smart Monitor belonging to the
  provided user, which for the purposes of this challenge will always succeed.

  The provided pid will receive a message with the result of the command after a 3 second
  delay, simulating the time it takes for the command to be processed by the device.
  """
  def send(_user_email, command, pid) do
    spawn(fn ->
      Process.sleep(3000)
      send(pid, {:ok, command})
    end)

    :ok
  end
end

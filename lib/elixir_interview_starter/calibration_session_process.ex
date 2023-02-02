defmodule ElixirInterviewStarter.CalibrationSessionProcess do
  use GenServer

  @moduledoc """
  CalibrationSessionProcess is a GenServer that manages the state of a calibration session.
  """

  alias ElixirInterviewStarter.CalibrationSession

  # Client

  def start_link(user_email) do
    GenServer.start_link(__MODULE__, %CalibrationSession{user_email: user_email})
  end

  def get_session(pid) do
    GenServer.call(pid, :get_session)
  end

  # Server

  @impl true
  def init(args) do
    {:ok, args}
  end

  @impl true
  def handle_call(:get_session, _from, state) do
    {:reply, state, state}
  end
end

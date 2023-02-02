defmodule ElixirInterviewStarter.CalibrationSessionProcess do
  use GenServer

  @moduledoc """
  CalibrationSessionProcess is a GenServer that manages the state of a calibration session.
  """

  alias ElixirInterviewStarter.DeviceMessages
  alias ElixirInterviewStarter.CalibrationSession

  # Client

  def start_link(user_email) do
    GenServer.start_link(__MODULE__, %CalibrationSession{user_email: user_email})
  end

  def get_session(pid) do
    GenServer.call(pid, :get_session)
  end

  def start_precheck_2(pid) do
    GenServer.call(pid, :start_precheck_2)
  end

  # Server

  @impl true
  def init(args = %CalibrationSession{user_email: user_email}) do
    args =
      if :ok == DeviceMessages.send(user_email, "startPrecheck1") do
        %CalibrationSession{args | step: "prechecked1"}
      end

    {:ok, args}
  end

  @impl true
  def handle_call(:start_precheck_2, _from, %CalibrationSession{step: "prechecked1"} = state) do
    state = %CalibrationSession{state | step: "precheck2"}

    if :ok == DeviceMessages.send(state.user_email, "startPrecheck2") do
      state = %CalibrationSession{state | step: "prechecked2"}
      {:reply, {:ok, state}, state}
    else
      {:reply, :error, state}
    end
  end

  def handle_call(:start_precheck_2, _from, %CalibrationSession{step: _step} = state) do
    {:reply, {:error, "device is not ready to precheck_2 or device has completed precheck_2 "}, state}
  end

  @impl true
  def handle_call(:get_session, _from, state) do
    {:reply, state, state}
  end
end

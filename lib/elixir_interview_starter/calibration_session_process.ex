defmodule ElixirInterviewStarter.CalibrationSessionProcess do
  use GenServer

  @moduledoc """
  CalibrationSessionProcess is a GenServer that manages the state of a calibration session
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

  def start_calibration(pid) do
    GenServer.call(pid, :start_calibration)
  end

  # Server

  @impl true
  def init(args = %CalibrationSession{user_email: user_email}) do
    DeviceMessages.send(user_email, "startPrecheck1", self())
    Process.send_after(self(), {:ok, "precheck1Timeout"}, 30_000)
    args = %CalibrationSession{args | step: "precheck1"}
    {:ok, args}
  end

  @impl true
  def handle_call(:start_precheck_2, _from, %CalibrationSession{step: "prechecked1", user_email: user_email} = state) do
    DeviceMessages.send(user_email, "startPrecheck2", self())
    Process.send_after(self(), {:ok, "precheck2Timeout"}, 30_000)
    state = %CalibrationSession{state | step: "precheck2"}
    {:reply, {:ok, state}, state}
  end

  def handle_call(:start_precheck_2, _from, %CalibrationSession{step: _step} = state) do
    {:reply, {:error, "device is not ready to precheck_2 or device has completed precheck_2 "}, state}
  end

  @impl true
  def handle_call(:get_session, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info({:ok, "startPrecheck1"}, state) do
    state = %CalibrationSession{state | step: "prechecked1"}
    {:noreply, state}
  end

  @impl true
  def handle_info({:ok, "startPrecheck2"}, state) do
    DeviceMessages.send(state.user_email, "calibrate", self())
    Process.send_after(self(), {:ok, "calibrateTimeout"}, 100_000)
    state = %CalibrationSession{state | step: "prechecked2"}
    {:noreply, state}
  end

  @impl true
  def handle_info({:ok, "calibrate"}, state) do
    state = %CalibrationSession{state | step: "calibrated"}
    {:noreply, state}
  end

  @impl true
  def handle_info({:ok, "precheck1Timeout"}, %CalibrationSession{step: "precheck1"} = state) do
    state = %CalibrationSession{state | step: "fail_session"}
    {:noreply, state}
  end

  @impl true
  def handle_info({:ok, "precheck2Timeout"}, %CalibrationSession{step: "precheck2"} = state) do
    state = %CalibrationSession{state | step: "fail_session"}
    {:noreply, state}
  end

  @impl true
  def handle_info({:ok, "calibrateTimeout"}, %CalibrationSession{step: "calibrate"} = state) do
    state = %CalibrationSession{state | step: "fail_session"}
    {:noreply, state}
  end
end

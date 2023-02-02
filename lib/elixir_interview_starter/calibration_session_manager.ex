defmodule ElixirInterviewStarter.CalibrationSessionManager do
  use GenServer

  @moduledoc """
  CalibrationSessionManager is a GenServer that manages the creation and routing of a calibration session process.
  """

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def start_session(user_email) do
    GenServer.call(__MODULE__, {:start_session, user_email})
  end

  def get_current_session(user_email) do
    GenServer.call(__MODULE__, {:get_current_session, user_email})
  end

  # Server

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:start_session, user_email}, _from, state) do
    if Map.has_key?(state, user_email) do
      {:reply, {:error, :already_in_progress}, state}
    else
      {:ok, pid} = DynamicSupervisor.start_child(App.ProcessSupervisor, {ElixirInterviewStarter.CalibrationSessionProcess, user_email})
      state = Map.put(state, user_email, pid)
      {:reply, :ok, state}
    end
  end

  @impl true
  def handle_call({:get_current_session, user_email}, _from, state) do
    current_session = Map.get(state, user_email)
    {:reply, {:ok, current_session}, state}
  end
end

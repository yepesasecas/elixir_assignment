defmodule ElixirInterviewStarter do
  @moduledoc """
  See `README.md` for instructions on how to approach this technical challenge.
  """

  alias ElixirInterviewStarter.CalibrationSession
  alias ElixirInterviewStarter.CalibrationSessionManager
  alias ElixirInterviewStarter.CalibrationSessionProcess

  @spec start(user_email :: String.t()) :: {:ok, CalibrationSession.t()} | {:error, String.t()}
  @doc """
  Creates a new `CalibrationSession` for the provided user, starts a `GenServer` process
  for the session, and starts precheck 1.

  If the user already has an ongoing `CalibrationSession`, returns an error.
  """
  def start(user_email) do
    case CalibrationSessionManager.start_session(user_email) do
      {:ok, pid} ->
        {:ok, CalibrationSessionProcess.get_session(pid)}

      {:error, :already_in_progress} ->
        {:error, "User already has an ongoing calibration session"}
    end
  end

  @spec start_precheck_2(user_email :: String.t()) ::
          {:ok, CalibrationSession.t()} | {:error, String.t()}
  @doc """
  Starts the precheck 2 step of the ongoing `CalibrationSession` for the provided user.

  If the user has no ongoing `CalibrationSession`, their `CalibrationSession` is not done
  with precheck 1, or their calibration session has already completed precheck 2, returns
  an error.
  """
  def start_precheck_2(user_email) do
    case CalibrationSessionManager.get_current_session(user_email) do
      {:ok, nil} ->
        {:error, "User has no ongoing calibration session"}

      {:ok, pid} ->
        CalibrationSessionProcess.start_precheck_2(pid)
    end
  end

  @spec get_current_session(user_email :: String.t()) :: {:ok, CalibrationSession.t() | nil}
  @doc """
  Retrieves the ongoing `CalibrationSession` for the provided user, if they have one
  """
  def get_current_session(user_email) do
    case CalibrationSessionManager.get_current_session(user_email) do
      {:ok, nil} ->
        nil

      {:ok, pid} ->
        {:ok, CalibrationSessionProcess.get_session(pid)}
    end
  end
end

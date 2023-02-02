defmodule ElixirInterviewStarterTest do
  use ExUnit.Case

  alias ElixirInterviewStarter.CalibrationSessionManager
  alias ElixirInterviewStarter.CalibrationSessionProcess
  alias ElixirInterviewStarter.CalibrationSession

  doctest ElixirInterviewStarter

  test "it can go through the whole flow happy path" do
  end

  test "start/1 creates a new calibration session and starts precheck 1" do
    CalibrationSessionManager.start_session("test1@test.com")

    assert {:ok, pid} = CalibrationSessionManager.get_current_session("test1@test.com")
    assert %CalibrationSession{user_email: "test1@test.com", step: "precheck1"} = CalibrationSessionProcess.get_session(pid)
  end

  test "start/1 returns an error if the provided user already has an ongoing calibration session" do
    CalibrationSessionManager.start_session("test2@test.com")

    assert {:error, :already_in_progress} = CalibrationSessionManager.start_session("test2@test.com")
  end

  test "start_precheck_2/1 starts precheck 2" do
  end

  test "start_precheck_2/1 returns an error if the provided user does not have an ongoing calibration session" do
  end

  test "start_precheck_2/1 returns an error if the provided user's ongoing calibration session is not done with precheck 1" do
  end

  test "start_precheck_2/1 returns an error if the provided user's ongoing calibration session is already done with precheck 2" do
  end

  test "get_current_session/1 returns the provided user's ongoing calibration session" do
  end

  test "get_current_session/1 returns nil if the provided user has no ongoing calibrationo session" do
  end
end

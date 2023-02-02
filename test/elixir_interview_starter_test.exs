defmodule ElixirInterviewStarterTest do
  use ExUnit.Case
  alias ElixirInterviewStarter.CalibrationSession

  doctest ElixirInterviewStarter

  test "it can go through the whole flow happy path" do
    assert {:ok, %CalibrationSession{step: "precheck1"}} = ElixirInterviewStarter.start("happy_user@test.com")
    #  wait device to precheck1
    Process.sleep(4000)
    assert {:ok, %CalibrationSession{step: "prechecked1"}} = ElixirInterviewStarter.get_current_session("happy_user@test.com")
    assert {:ok, %CalibrationSession{step: "precheck2"}} = ElixirInterviewStarter.start_precheck_2("happy_user@test.com")
    # wait device to precheck2
    Process.sleep(4000)
    assert {:ok, %CalibrationSession{step: "prechecked2"}} = ElixirInterviewStarter.get_current_session("happy_user@test.com")
    # wait device to calibrate
    Process.sleep(4000)
    assert {:ok, %CalibrationSession{step: "calibrated"}} = ElixirInterviewStarter.get_current_session("happy_user@test.com")
  end

  test "start/1 creates a new calibration session and starts precheck 1" do
    assert {:ok, %CalibrationSession{}} = ElixirInterviewStarter.start("user1@test.com")
  end

  test "start/1 returns an error if the provided user already has an ongoing calibration session" do
    ElixirInterviewStarter.start("user2@test.com")
    assert {:error, _message} = ElixirInterviewStarter.start("user2@test.com")
  end

  test "start_precheck_2/1 starts precheck 2" do
    ElixirInterviewStarter.start("user3@test.com")
    Process.sleep(4000)
    assert {:ok, %CalibrationSession{}} = ElixirInterviewStarter.start_precheck_2("user3@test.com")
  end

  test "start_precheck_2/1 returns an error if the provided user does not have an ongoing calibration session" do
    assert {:error, _message} = ElixirInterviewStarter.start_precheck_2("non_existing_user@test.com")
  end

  test "start_precheck_2/1 returns an error if the provided user's ongoing calibration session is not done with precheck 1" do
    ElixirInterviewStarter.start("user4@test.com")
    assert {:error, _message} = ElixirInterviewStarter.start_precheck_2("user3@test.com")
  end

  test "start_precheck_2/1 returns an error if the provided user's ongoing calibration session is already done with precheck 2" do
    ElixirInterviewStarter.start("user5@test.com")
    Process.sleep(4000)
    ElixirInterviewStarter.start_precheck_2("user5@test.com")
    assert {:error, _message} = ElixirInterviewStarter.start_precheck_2("user5@test.com")
  end

  test "get_current_session/1 returns the provided user's ongoing calibration session" do
    ElixirInterviewStarter.start("user6@test.com")
    assert {:ok, %CalibrationSession{}} = ElixirInterviewStarter.get_current_session("user6@test.com")
  end

  test "get_current_session/1 returns nil if the provided user has no ongoing calibrationo session" do
    assert nil == ElixirInterviewStarter.get_current_session("non_exisiting_user_2@test.com")
  end
end

defmodule ElixirInterviewStarter.CalibrationSession do
  @moduledoc """
  A struct representing an ongoing calibration session, used to identify who the session
  belongs to, what step the session is on, and any other information relevant to working
  with the session.
  """

  @type t() :: %__MODULE__{}

  @doc """
  The user_email field is a string representing the email address of the user who owns
  the calibration session.

  The step field is a string representing the current step of the calibration session.
  The possible values are:
    - "precheck1"
    - "prechecked1"
    - "precheck2"
    - "prechecked2"
    - "calibration"
    - "calibrated"
    - "fail_session
  """
  defstruct [:user_email, step: "precheck1"]
end

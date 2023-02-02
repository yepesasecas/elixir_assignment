defmodule ElixirInterviewStarter.CalibrationSession do
  @moduledoc """
  A struct representing an ongoing calibration session, used to identify who the session
  belongs to, what step the session is on, and any other information relevant to working
  with the session.
  """

  @type t() :: %__MODULE__{}

  # precheck1, prechecked1, precheck2, prechecked2, calibrate, calibrated
  defstruct [:user_email, step: "precheck1"]
end

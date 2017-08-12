defmodule Phauxth.Confirm.Report do
  @moduledoc """
  Log and report information and errors.
  """

  alias Phauxth.{Config, Log}

  @doc """
  Print out a log message and then return {:ok, user} or
  {:error, message} to the calling function.
  """
  def report(%{reset_sent_at: nil}, meta, :pass_reset) do
    Log.warn(%Log{message: "no reset token found", meta: meta})
    {:error, "The user has not been sent a reset token"}
  end
  def report(%{reset_sent_at: time} = user, meta, :pass_reset) when not is_nil(time) do
    Log.info(%Log{user: user.id, message: "user confirmed for password reset", meta: meta})
    {:ok, Map.drop(user, Config.drop_user_keys)}
  end
  def report(%{confirmed_at: nil} = user, meta, _) do
    Log.info(%Log{user: user.id, message: "user confirmed", meta: meta})
    {:ok, Map.drop(user, Config.drop_user_keys)}
  end
  def report(%{} = user, meta, _) do
    Log.warn(%Log{user: user.id, message: "user already confirmed", meta: meta})
    {:error, "The user has already been confirmed"}
  end
  def report({:error, message}, meta, _) do
    Log.warn(%Log{message: message, meta: meta})
    {:error, "Invalid credentials"}
  end
  def report(nil, meta, _), do: report({:error, "no user found"}, meta, nil)
end
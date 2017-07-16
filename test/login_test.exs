defmodule Phauxth.LoginTest do
  use ExUnit.Case
  use Plug.Test

  alias Phauxth.{Argon2Login, CustomLogin, Login, TestAccounts}

  test "login succeeds with email" do
    params = %{"email" => "fred+1@mail.com", "password" => "h4rd2gU3$$"}
    {:ok, %{email: email}} = Login.verify(params, TestAccounts)
    assert email == "fred+1@mail.com"
  end

  test "login succeeds with username" do
    params = %{"username" => "fred", "password" => "h4rd2gU3$$"}
    {:ok, %{username: username}} = Login.verify(params, TestAccounts, [identifier: :username])
    assert username == "fred"
  end

  test "login fails for incorrect password" do
    params = %{"email" => "fred+1@mail.com", "password" => "oohwhatwasitagain"}
    {:error, message} = Login.verify(params, TestAccounts)
    assert message =~ "Invalid credentials"
  end

  test "login fails for invalid username" do
    params = %{"username" => "dick", "password" => "h4rd2gU3$$"}
    {:error, message} = Login.verify(params, TestAccounts, [identifier: :username])
    assert message =~ "Invalid credentials"
  end

  test "login fails for invalid email" do
    params = %{"email" => "dick@mail.com", "password" => "h4rd2gU3$$"}
    {:error, message} = Login.verify(params, TestAccounts)
    assert message =~ "Invalid credentials"
  end

  test "output to current_user does not contain password_hash" do
    params = %{"email" => "fred+1@mail.com", "password" => "h4rd2gU3$$"}
    {:ok, user} = Login.verify(params, TestAccounts)
    refute Map.has_key?(user, :password_hash)
    refute Map.has_key?(user, :otp_secret)
  end

  test "use a custom check_pass" do
    params = %{"email" => "frank@mail.com", "password" => "h4rd2gU3$$"}
    {:ok, %{email: email}} = CustomLogin.verify(params, TestAccounts)
    assert email == "frank@mail.com"
  end

  test "login fails for invalid email with custom check_pass" do
    params = %{"email" => "oranges@mail.com", "password" => "h4rd2gU3$$"}
    {:error, message} = CustomLogin.verify(params, TestAccounts)
    assert message =~ "Invalid credentials"
  end

  test "login with different crypto module" do
    params = %{"email" => "frank@mail.com", "password" => "h4rd2gU3$$"}
    {:ok, %{email: email}} = Argon2Login.verify(params, TestAccounts)
    assert email == "frank@mail.com"
  end

  test "login with different crypto module fails for wrong password" do
    params = %{"email" => "frank@mail.com", "password" => "password"}
    {:error, message} = Argon2Login.verify(params, TestAccounts)
    assert message =~ "Invalid credentials"
  end

end

Logger.configure(level: :info)
alias Phauxth.TestRepo

Application.put_env(:phauxth, :pg_test_url,
  "ecto://" <> (System.get_env("PG_URL") || "postgres:postgres@localhost")
)

Application.put_env(:phauxth, TestRepo,
  adapter: Ecto.Adapters.Postgres,
  url: Application.get_env(:phauxth, :pg_test_url) <> "/phauxth_test",
  pool: Ecto.Adapters.SQL.Sandbox)

defmodule Phauxth.TestRepo do
  use Ecto.Repo, otp_app: :phauxth
end

defmodule UsersMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :encrypted_password, :string
      add :role, :string
      add :otp_required, :boolean
      add :otp_secret, :string
      add :otp_last, :integer
    end

    create unique_index :users, [:email]
  end
end

defmodule Phauxth.TestUser do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :encrypted_password, :string
    field :role, :string
    field :otp_required, :boolean
    field :otp_secret, :string
    field :otp_last, :integer
  end
end

defmodule Phauxth.TestCase do
  use ExUnit.CaseTemplate

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TestRepo)
  end
end

{:ok, _} = Ecto.Adapters.Postgres.ensure_all_started(TestRepo, :temporary)

_   = Ecto.Adapters.Postgres.storage_down(TestRepo.config)
:ok = Ecto.Adapters.Postgres.storage_up(TestRepo.config)

{:ok, _pid} = TestRepo.start_link

:ok = Ecto.Migrator.up(TestRepo, 0, UsersMigration, log: false)
Ecto.Adapters.SQL.Sandbox.mode(TestRepo, :manual)

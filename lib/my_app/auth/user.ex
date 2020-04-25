defmodule MyApp.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :is_active, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :is_active, :password])
    |> validate_required([:email, :is_active, :password])
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def put_password_hash(
        %Ecto.Chageset{valid?: true, chages: %{password: password}} = changeset
      ) do
    change(changeset, Bycript.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

end

defmodule Blogo.Tag do
  @moduledoc """
  Tag entity and schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: binary() | nil,
          name: String.t(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @timestamps_opts [type: :utc_datetime]
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tags" do
    field :name, :string

    many_to_many :posts, Blogo.Post, join_through: "posts_tags"
    many_to_many :authors, Blogo.Author, join_through: "authors_tags"
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end

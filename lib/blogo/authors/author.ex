defmodule Blogo.Author do
  @moduledoc """
  Author entity and schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: binary() | nil,
          name: String.t(),
          age: non_neg_integer(),
          country: String.t(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authors" do
    field :age, :integer
    field :country, :string
    field :name, :string

    many_to_many :posts, Blogo.Post, join_through: "authors_posts"
    many_to_many :tags, Blogo.Tag, join_through: "authors_tags"
    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :age, :country])
    |> validate_required([:name, :age, :country])
  end
end

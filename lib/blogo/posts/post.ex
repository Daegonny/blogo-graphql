defmodule Blogo.Post do
  @moduledoc """
  Post entity and schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: binary() | nil,
          title: String.t(),
          views: non_neg_integer(),
          inserted_at: DateTime.t() | nil,
          updated_at: DateTime.t() | nil
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :title, :string
    field :views, :integer

    many_to_many :authors, Blogo.Author, join_through: "author_posts"
    many_to_many :tags, Blogo.Tag, join_through: "posts_tags"
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :views])
    |> validate_required([:title, :content, :views])
  end
end

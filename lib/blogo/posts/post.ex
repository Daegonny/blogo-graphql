defmodule Blogo.Post do
  @moduledoc """
  Post entity and schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :content, :string
    field :title, :string
    field :views, :integer

    many_to_many :tags, Blogo.Tag, join_through: "posts_tags"
    many_to_many :authors, Blogo.Author, join_through: "author_posts"
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :views])
    |> validate_required([:title, :content, :views])
  end
end

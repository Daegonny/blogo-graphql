defmodule Blogo.Repo.Migrations.CreatePostsTags do
  use Ecto.Migration

  def change do
    create table(:posts_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :post_id, references(:posts, type: :binary_id)
      add :tag_id, references(:tags, type: :binary_id)
    end

    create unique_index(:posts_tags, [:post_id, :tag_id])
  end
end

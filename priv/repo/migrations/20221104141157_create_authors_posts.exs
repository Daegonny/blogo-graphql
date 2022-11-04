defmodule Blogo.Repo.Migrations.CreateAuthorsPosts do
  use Ecto.Migration

  def change do
    create table(:authors_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author_id, references(:authors, type: :binary_id)
      add :post_id, references(:posts, type: :binary_id)
    end

    create unique_index(:authors_posts, [:author_id, :post_id])
  end
end

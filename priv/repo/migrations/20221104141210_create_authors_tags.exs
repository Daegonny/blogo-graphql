defmodule Blogo.Repo.Migrations.CreateAuthorsTags do
  use Ecto.Migration

  def change do
    create table(:authors_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :author_id, references(:authors, type: :binary_id)
      add :tag_id, references(:tags, type: :binary_id)
    end

    create unique_index(:authors_tags, [:author_id, :tag_id])
  end
end

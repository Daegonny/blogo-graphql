defmodule Blogo.AuthorsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.Authors

  describe "get/1" do
    test "returns existing author" do
      author = insert(:author)
      loaded_author = Authors.get(author.id)
      assert loaded_author == author
    end

    test "returns nil when author does not exists" do
      nonexistent_id = Ecto.UUID.generate()
      assert Authors.get(nonexistent_id) == nil
    end
  end

  describe "all/0" do
    test "returns all existing authors" do
      authors = insert_list(5, :author) |> MapSet.new()
      loaded_authors = Authors.all() |> MapSet.new()
      assert MapSet.equal?(loaded_authors, authors)
    end

    test "returns empty list when there is no authors" do
      assert [] = Authors.all()
    end
  end
end

defmodule Blogo.AuthorsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.Authors

  describe "get/1" do
    test "returns existing author" do
      author = insert(:author)
      author_loaded = Authors.get(author.id)
      assert author_loaded == author
    end

    test "returns nil when author does not exists" do
      nonexistent_id = Ecto.UUID.generate()
      assert Authors.get(nonexistent_id) == nil
    end
  end
end

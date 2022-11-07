defmodule Blogo.TagsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.Tags

  describe "get/1" do
    test "returns existing tag" do
      tag = insert(:tag)
      loaded_tag = Tags.get(tag.id)
      assert loaded_tag == tag
    end

    test "returns nil when tag does not exists" do
      nonexistent_id = Ecto.UUID.generate()
      assert Tags.get(nonexistent_id) == nil
    end
  end

  describe "all/1" do
    test "returns all existing tags" do
      tags = insert_list(5, :tag) |> MapSet.new()
      loaded_tags = Tags.all() |> MapSet.new()
      assert MapSet.equal?(loaded_tags, tags)
    end

    test "returns empty list when there is no tags" do
      assert [] = Tags.all()
    end
  end
end

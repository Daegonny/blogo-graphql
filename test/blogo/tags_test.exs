defmodule Blogo.TagsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.{Tag, Tags}

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

  describe "all/0" do
    test "returns all existing tags" do
      tags = insert_list(5, :tag) |> MapSet.new()
      loaded_tags = Tags.all() |> MapSet.new()
      assert MapSet.equal?(loaded_tags, tags)
    end

    test "returns empty list when there is no tags" do
      assert [] = Tags.all()
    end
  end

  describe "all/1" do
    test "returns tags limited by quantity" do
      limit = 3
      insert_list(5, :tag)
      limited_tags = Tags.all(%{limit: limit})
      assert Enum.count(limited_tags) == limit
    end

    test "returns tags sorted by name" do
      %Tag{id: id_3} = insert(:tag, name: "C")
      %Tag{id: id_2} = insert(:tag, name: "B")
      %Tag{id: id_1} = insert(:tag, name: "A")

      sorted_tags = Tags.all(%{sort_by: [%{field: :name, order: :asc}]})
      sorted_tags_ids = Enum.map(sorted_tags, & &1.id)
      assert [id_1, id_2, id_3] == sorted_tags_ids
    end

    test "returns tags sorted by inserted_at" do
      %Tag{id: id_1} = insert(:tag, inserted_at: "2000-01-01 00:00:03")
      %Tag{id: id_2} = insert(:tag, inserted_at: "2000-01-01 00:00:02")
      %Tag{id: id_3} = insert(:tag, inserted_at: "2000-01-01 00:00:01")

      sorted_tags = Tags.all(%{sort_by: [%{field: :inserted_at, order: :desc}]})
      sorted_tags_ids = Enum.map(sorted_tags, & &1.id)
      assert [id_1, id_2, id_3] == sorted_tags_ids
    end

    test "returns tags filtered by text_search" do
      %Tag{id: id_1} = insert(:tag, name: "Um Queijo prato")
      %Tag{id: id_2} = insert(:tag, name: "ali havia queijo")
      insert(:tag, name: "apenas sem lactose")
      %Tag{id: id_4} = insert(:tag, name: "QUEIJO gorgonzola")

      filtered_tags = Tags.all(%{filters: %{text_search: "queijo"}})
      filtered_tag_ids = Enum.map(filtered_tags, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_1, id_2, id_4])

      assert MapSet.equal?(ids, filtered_tag_ids)
    end

    test "returns tags filtered by min_inserted_at and max_inserted_at range" do
      insert(:tag, inserted_at: "2000-01-01 00:00:01")
      %Tag{id: id_2} = insert(:tag, inserted_at: "2000-01-01 00:00:02")
      %Tag{id: id_3} = insert(:tag, inserted_at: "2000-01-01 00:00:03")
      insert(:tag, inserted_at: "2000-01-01 00:00:04")

      filtered_tags =
        Tags.all(%{
          filters: %{
            min_inserted_at: "2000-01-01 00:00:02",
            max_inserted_at: "2000-01-01 00:00:03"
          }
        })

      filtered_tag_ids = Enum.map(filtered_tags, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_2, id_3])

      assert MapSet.equal?(ids, filtered_tag_ids)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Tag{id: id_2} = insert(:tag, name: "B letra")
      %Tag{id: id_3} = insert(:tag, name: "C letra")
      %Tag{id: id_1} = insert(:tag, name: "A letra")
      insert(:tag, name: "D letra")
      insert(:tag, name: "1 numero")

      filtered_tags =
        Tags.all(%{
          limit: 3,
          filters: %{text_search: "letra"},
          sort_by: [%{field: :name, order: :asc}]
        })

      filtered_tag_ids = Enum.map(filtered_tags, & &1.id)
      assert [id_1, id_2, id_3] == filtered_tag_ids
    end
  end
end

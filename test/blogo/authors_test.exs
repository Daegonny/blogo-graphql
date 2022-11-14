defmodule Blogo.AuthorsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.{Author, Authors}

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

  describe "all/1" do
    test "returns authors limited by quantity" do
      limit = 3
      insert_list(5, :author)
      limited_authors = Authors.all(%{limit: limit})
      assert Enum.count(limited_authors) == limit
    end

    test "returns authors sorted by name" do
      %Author{id: id_3} = insert(:author, name: "C")
      %Author{id: id_2} = insert(:author, name: "B")
      %Author{id: id_1} = insert(:author, name: "A")

      sorted_authors = Authors.all(%{sort_by: [%{field: :name, order: :asc}]})
      sorted_authors_ids = Enum.map(sorted_authors, & &1.id)
      assert [id_1, id_2, id_3] == sorted_authors_ids
    end

    test "returns authors sorted by country" do
      %Author{id: id_3} = insert(:author, country: "C")
      %Author{id: id_2} = insert(:author, country: "B")
      %Author{id: id_1} = insert(:author, country: "A")

      sorted_authors = Authors.all(%{sort_by: [%{field: :country, order: :asc}]})
      sorted_authors_ids = Enum.map(sorted_authors, & &1.id)
      assert [id_1, id_2, id_3] == sorted_authors_ids
    end

    test "returns authors sorted by age" do
      %Author{id: id_3} = insert(:author, age: 3)
      %Author{id: id_2} = insert(:author, age: 2)
      %Author{id: id_1} = insert(:author, age: 1)

      loaded_authors = Authors.all(%{sort_by: [%{field: :age, order: :asc}]})
      loaded_author_ids = Enum.map(loaded_authors, & &1.id)
      assert [id_1, id_2, id_3] == loaded_author_ids
    end

    test "returns authors sorted by inserted_at" do
      %Author{id: id_1} = insert(:author, inserted_at: "2000-01-01 00:00:03")
      %Author{id: id_2} = insert(:author, inserted_at: "2000-01-01 00:00:02")
      %Author{id: id_3} = insert(:author, inserted_at: "2000-01-01 00:00:01")

      sorted_authors = Authors.all(%{sort_by: [%{field: :inserted_at, order: :desc}]})
      sorted_authors_ids = Enum.map(sorted_authors, & &1.id)
      assert [id_1, id_2, id_3] == sorted_authors_ids
    end

    test "returns authors filtered by text_search" do
      %Author{id: id_1} = insert(:author, name: "Um Queijo prato")
      %Author{id: id_2} = insert(:author, name: "ali havia queijo")
      insert(:author, name: "apenas sem lactose")
      %Author{id: id_4} = insert(:author, country: "QUEIJO gorgonzola")

      filtered_authors = Authors.all(%{filters: %{text_search: "queijo"}})
      filtered_author_ids = Enum.map(filtered_authors, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_1, id_2, id_4])

      assert MapSet.equal?(ids, filtered_author_ids)
    end

    test "returns authors filtered by min_age and max_age range" do
      insert(:author, age: 1)
      %Author{id: id_2} = insert(:author, age: 2)
      %Author{id: id_3} = insert(:author, age: 3)
      insert(:author, age: 4)

      filtered_authors = Authors.all(%{filters: %{min_age: 2, max_age: 3}})
      filtered_author_ids = Enum.map(filtered_authors, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_2, id_3])

      assert MapSet.equal?(ids, filtered_author_ids)
    end

    test "returns authors filtered by min_inserted_at and max_inserted_at range" do
      insert(:author, inserted_at: "2000-01-01 00:00:01")
      %Author{id: id_2} = insert(:author, inserted_at: "2000-01-01 00:00:02")
      %Author{id: id_3} = insert(:author, inserted_at: "2000-01-01 00:00:03")
      insert(:author, inserted_at: "2000-01-01 00:00:04")

      filtered_authors =
        Authors.all(%{
          filters: %{
            min_inserted_at: "2000-01-01 00:00:02",
            max_inserted_at: "2000-01-01 00:00:03"
          }
        })

      filtered_author_ids = Enum.map(filtered_authors, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_2, id_3])

      assert MapSet.equal?(ids, filtered_author_ids)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Author{id: id_2} = insert(:author, name: "B letra")
      %Author{id: id_3} = insert(:author, name: "C letra")
      %Author{id: id_1} = insert(:author, name: "A letra")
      insert(:author, name: "D letra")
      insert(:author, name: "1 numero")

      filtered_authors =
        Authors.all(%{
          limit: 3,
          filters: %{text_search: "letra"},
          sort_by: [%{field: :name, order: :asc}]
        })

      filtered_author_ids = Enum.map(filtered_authors, & &1.id)
      assert [id_1, id_2, id_3] == filtered_author_ids
    end
  end
end

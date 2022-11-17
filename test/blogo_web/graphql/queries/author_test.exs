defmodule BlogoWeb.Graphql.Queries.AuthorTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias BlogoWeb.Graphql.Schema
  alias Blogo.Author

  describe "author query" do
    test "returns existing author" do
      author = insert(:author)

      query = """
      query{
        author(id: "#{author.id}"){
          id
          name
          country
          age
          inserted_at
        }
      }
      """

      assert %{data: %{"author" => returned_author}} = Absinthe.run!(query, Schema)

      requested_fields = MapSet.new(~w(id name country age inserted_at))

      returned_fields =
        returned_author
        |> Map.keys()
        |> MapSet.new()

      refute is_nil(returned_author)
      assert returned_author["id"] == author.id
      assert MapSet.equal?(returned_fields, requested_fields)
    end

    test "returns nil when author does not exists" do
      nonexistent_id = Ecto.UUID.generate()

      query = """
      query{
        author(id: "#{nonexistent_id}"){
          id
          name
          country
          age
          inserted_at
        }
      }
      """

      assert %{
               data: %{"author" => nil},
               errors: [
                 %{
                   code: :not_found,
                   message: "Resource not found",
                   path: ["author"],
                   status_code: 404
                 }
               ]
             } = Absinthe.run!(query, Schema)
    end
  end

  describe "authors query" do
    test "returns all existing authors" do
      authors = insert_list(5, :author)
      authors_ids = Enum.map(authors, & &1.id) |> MapSet.new()

      query = """
      query{
        authors{
          id
          name
          country
          age
          inserted_at
        }
      }
      """

      assert %{data: %{"authors" => returned_authors}} = Absinthe.run!(query, Schema)
      assert Enum.count(returned_authors) == 5
      returned_author_ids = Enum.map(returned_authors, & &1["id"]) |> MapSet.new()
      assert MapSet.equal?(returned_author_ids, authors_ids)
    end

    test "returns empty list when there is no authors" do
      query = """
      query{
        authors{
          id
          name
          country
          age
          inserted_at
        }
      }
      """

      assert %{data: %{"authors" => []}} = Absinthe.run!(query, Schema)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Author{id: id_2} = insert(:author, name: "B letra")
      %Author{id: id_3} = insert(:author, name: "C letra")
      %Author{id: id_1} = insert(:author, name: "A letra")
      insert(:author, name: "D letra")
      insert(:author, name: "1 numero")

      query = """
      query{
        authors(queryParams: {
          limit: 3,
          filters: {
            textSearch: "letra"
          },
          sortBy: [
            {
              field: NAME,
              order: ASC
            }
          ]
        }){
          id
          name
          country
          age
          inserted_at
        }
      }
      """

      assert %{data: %{"authors" => filtered_authors}} = Absinthe.run!(query, Schema)

      filtered_author_ids = Enum.map(filtered_authors, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_author_ids
    end
  end
end

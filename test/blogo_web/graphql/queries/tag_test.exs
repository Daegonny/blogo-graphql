defmodule BlogoWeb.Graphql.Queries.TagTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias BlogoWeb.Graphql.Schema
  alias Blogo.Tag

  describe "tag query" do
    test "returns existing tag" do
      tag = insert(:tag)

      query = """
      query{
        tag(id: "#{tag.id}"){
          id
          name
        }
      }
      """

      assert %{data: %{"tag" => returned_tag}} = Absinthe.run!(query, Schema)

      requested_fields = MapSet.new(~w(id name))

      returned_fields =
        returned_tag
        |> Map.keys()
        |> MapSet.new()

      refute is_nil(returned_tag)
      assert returned_tag["id"] == tag.id
      assert MapSet.equal?(returned_fields, requested_fields)
    end

    test "returns nil when tag does not exists" do
      nonexistent_id = Ecto.UUID.generate()

      query = """
      query{
        tag(id: "#{nonexistent_id}"){
          id
          name
        }
      }
      """

      assert %{
               data: %{"tag" => nil},
               errors: [
                 %{
                   code: :not_found,
                   message: "Resource not found",
                   path: ["tag"],
                   status_code: 404
                 }
               ]
             } = Absinthe.run!(query, Schema)
    end
  end

  describe "tags query" do
    test "returns all existing tags" do
      tags = insert_list(5, :tag)
      tags_ids = Enum.map(tags, & &1.id) |> MapSet.new()

      query = """
      query{
        tags{
          id
          name
        }
      }
      """

      assert %{data: %{"tags" => returned_tags}} = Absinthe.run!(query, Schema)
      assert Enum.count(returned_tags) == 5
      returned_tag_ids = Enum.map(returned_tags, & &1["id"]) |> MapSet.new()
      assert MapSet.equal?(returned_tag_ids, tags_ids)
    end

    test "returns empty list when there is no tags" do
      query = """
      query{
        tags{
          id
          name
        }
      }
      """

      assert %{data: %{"tags" => []}} = Absinthe.run!(query, Schema)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Tag{id: id_2} = insert(:tag, name: "B letra")
      %Tag{id: id_3} = insert(:tag, name: "C letra")
      %Tag{id: id_1} = insert(:tag, name: "A letra")
      insert(:tag, name: "D letra")
      insert(:tag, name: "1 numero")

      query = """
      query{
        tags(queryParams: {
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
        }
      }
      """

      assert %{data: %{"tags" => filtered_tags}} = Absinthe.run!(query, Schema)

      filtered_tag_ids = Enum.map(filtered_tags, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_tag_ids
    end
  end
end

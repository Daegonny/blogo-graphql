defmodule BlogoWeb.Graphql.Queries.AuthorTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias BlogoWeb.Graphql.Schema
  alias Blogo.{Author, Post, Repo, Tag}

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

    test "returns error not found when author does not exists" do
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

    test "applies limit, sort_by and filter to post children nodes" do
      author = insert(:author)

      %Post{id: id_2} = post_2 = insert(:post, title: "B letra")
      %Post{id: id_3} = post_3 = insert(:post, title: "C letra")
      %Post{id: id_1} = post_1 = insert(:post, title: "A letra")
      post_4 = insert(:post, title: "D letra")
      post_5 = insert(:post, title: "1 numero")

      {5, _} =
        Repo.insert_all(
          "authors_posts",
          Enum.map(
            [post_1, post_2, post_3, post_4, post_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              author_id: Ecto.UUID.dump!(author.id),
              post_id: Ecto.UUID.dump!(&1.id)
            }
          )
        )

      query = """
      query{
        authors{
          id
          posts(queryParams: {
            limit: 3,
            filters: {
              textSearch: "letra"
            },
            sortBy: [
              {
                field: TITLE,
                order: ASC
              }
            ]
          }){
            id
            title
            content
            views
            inserted_at
          }
        }
      }
      """

      assert %{data: %{"authors" => [%{"posts" => filtered_posts}]}} =
               Absinthe.run!(query, Schema)

      filtered_post_ids = Enum.map(filtered_posts, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_post_ids
    end

    test "applies limit, sort_by and filter to tag children nodes" do
      author = insert(:author)

      %Tag{id: id_2} = tag_2 = insert(:tag, name: "B letra")
      %Tag{id: id_3} = tag_3 = insert(:tag, name: "C letra")
      %Tag{id: id_1} = tag_1 = insert(:tag, name: "A letra")
      tag_4 = insert(:tag, name: "D letra")
      tag_5 = insert(:tag, name: "1 numero")

      {5, _} =
        Repo.insert_all(
          "authors_tags",
          Enum.map(
            [tag_1, tag_2, tag_3, tag_4, tag_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              author_id: Ecto.UUID.dump!(author.id),
              tag_id: Ecto.UUID.dump!(&1.id)
            }
          )
        )

      query = """
      query{
        authors{
          id
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
      }
      """

      assert %{data: %{"authors" => [%{"tags" => filtered_tags}]}} = Absinthe.run!(query, Schema)

      filtered_tag_ids = Enum.map(filtered_tags, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_tag_ids
    end
  end
end

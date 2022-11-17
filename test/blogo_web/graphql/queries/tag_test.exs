defmodule BlogoWeb.Graphql.Queries.TagTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias BlogoWeb.Graphql.Schema
  alias Blogo.{Author, Repo, Post, Tag}

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

    test "applies limit, sort_by and filter to author children nodes" do
      tag = insert(:tag)

      %Author{id: id_2} = author_2 = insert(:author, name: "B letra")
      %Author{id: id_3} = author_3 = insert(:author, name: "C letra")
      %Author{id: id_1} = author_1 = insert(:author, name: "A letra")
      author_4 = insert(:author, name: "D letra")
      author_5 = insert(:author, name: "1 numero")

      {5, _} =
        Repo.insert_all(
          "authors_tags",
          Enum.map(
            [author_1, author_2, author_3, author_4, author_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              author_id: Ecto.UUID.dump!(&1.id),
              tag_id: Ecto.UUID.dump!(tag.id)
            }
          )
        )

      query = """
      query{
        tags{
          id
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
      }
      """

      assert %{data: %{"tags" => [%{"authors" => filtered_authors}]}} =
               Absinthe.run!(query, Schema)

      filtered_author_ids = Enum.map(filtered_authors, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_author_ids
    end

    test "applies limit, sort_by and filter to post children nodes" do
      tag = insert(:tag)

      %Post{id: id_2} = post_2 = insert(:post, title: "B letra")
      %Post{id: id_3} = post_3 = insert(:post, title: "C letra")
      %Post{id: id_1} = post_1 = insert(:post, title: "A letra")
      post_4 = insert(:post, title: "D letra")
      post_5 = insert(:post, title: "1 numero")

      {5, _} =
        Repo.insert_all(
          "posts_tags",
          Enum.map(
            [post_1, post_2, post_3, post_4, post_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              tag_id: Ecto.UUID.dump!(tag.id),
              post_id: Ecto.UUID.dump!(&1.id)
            }
          )
        )

      query = """
      query{
        tags{
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

      assert %{data: %{"tags" => [%{"posts" => filtered_posts}]}} = Absinthe.run!(query, Schema)

      filtered_post_ids = Enum.map(filtered_posts, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_post_ids
    end
  end
end

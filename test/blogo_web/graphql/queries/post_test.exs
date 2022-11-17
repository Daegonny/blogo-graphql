defmodule BlogoWeb.Graphql.Queries.PostTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias BlogoWeb.Graphql.Schema
  alias Blogo.{Author, Repo, Post, Tag}

  describe "post query" do
    test "returns existing post" do
      post = insert(:post)

      query = """
      query{
        post(id: "#{post.id}"){
          id
          title
          content
          views
          inserted_at
        }
      }
      """

      assert %{data: %{"post" => returned_post}} = Absinthe.run!(query, Schema)

      requested_fields = MapSet.new(~w(id title content views inserted_at))

      returned_fields =
        returned_post
        |> Map.keys()
        |> MapSet.new()

      refute is_nil(returned_post)
      assert returned_post["id"] == post.id
      assert MapSet.equal?(returned_fields, requested_fields)
    end

    test "returns nil when post does not exists" do
      nonexistent_id = Ecto.UUID.generate()

      query = """
      query{
        post(id: "#{nonexistent_id}"){
          id
          title
          content
          views
          inserted_at
        }
      }
      """

      assert %{
               data: %{"post" => nil},
               errors: [
                 %{
                   code: :not_found,
                   message: "Resource not found",
                   path: ["post"],
                   status_code: 404
                 }
               ]
             } = Absinthe.run!(query, Schema)
    end
  end

  describe "posts query" do
    test "returns all existing posts" do
      posts = insert_list(5, :post)
      posts_ids = Enum.map(posts, & &1.id) |> MapSet.new()

      query = """
      query{
        posts{
          id
          title
          content
          views
          inserted_at
        }
      }
      """

      assert %{data: %{"posts" => returned_posts}} = Absinthe.run!(query, Schema)
      assert Enum.count(returned_posts) == 5
      returned_post_ids = Enum.map(returned_posts, & &1["id"]) |> MapSet.new()
      assert MapSet.equal?(returned_post_ids, posts_ids)
    end

    test "returns empty list when there is no posts" do
      query = """
      query{
        posts{
          id
          title
          content
          views
          inserted_at
        }
      }
      """

      assert %{data: %{"posts" => []}} = Absinthe.run!(query, Schema)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Post{id: id_2} = insert(:post, title: "B letra")
      %Post{id: id_3} = insert(:post, title: "C letra")
      %Post{id: id_1} = insert(:post, title: "A letra")
      insert(:post, title: "D letra")
      insert(:post, title: "1 numero")

      query = """
      query{
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
      """

      assert %{data: %{"posts" => filtered_posts}} = Absinthe.run!(query, Schema)

      filtered_post_ids = Enum.map(filtered_posts, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_post_ids
    end

    test "applies limit, sort_by and filter to author children nodes" do
      post = insert(:post)

      %Author{id: id_2} = author_2 = insert(:author, name: "B letra")
      %Author{id: id_3} = author_3 = insert(:author, name: "C letra")
      %Author{id: id_1} = author_1 = insert(:author, name: "A letra")
      author_4 = insert(:author, name: "D letra")
      author_5 = insert(:author, name: "1 numero")

      {5, _} =
        Repo.insert_all(
          "authors_posts",
          Enum.map(
            [author_1, author_2, author_3, author_4, author_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              author_id: Ecto.UUID.dump!(&1.id),
              post_id: Ecto.UUID.dump!(post.id)
            }
          )
        )

      query = """
      query{
        posts{
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

      assert %{data: %{"posts" => [%{"authors" => filtered_authors}]}} =
               Absinthe.run!(query, Schema)

      filtered_author_ids = Enum.map(filtered_authors, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_author_ids
    end

    test "applies limit, sort_by and filter to tag children nodes" do
      post = insert(:post)

      %Tag{id: id_2} = tag_2 = insert(:tag, name: "B letra")
      %Tag{id: id_3} = tag_3 = insert(:tag, name: "C letra")
      %Tag{id: id_1} = tag_1 = insert(:tag, name: "A letra")
      tag_4 = insert(:tag, name: "D letra")
      tag_5 = insert(:tag, name: "1 numero")

      {5, _} =
        Repo.insert_all(
          "posts_tags",
          Enum.map(
            [tag_1, tag_2, tag_3, tag_4, tag_5],
            &%{
              id: Ecto.UUID.dump!(Ecto.UUID.generate()),
              post_id: Ecto.UUID.dump!(post.id),
              tag_id: Ecto.UUID.dump!(&1.id)
            }
          )
        )

      query = """
      query{
        posts{
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

      assert %{data: %{"posts" => [%{"tags" => filtered_tags}]}} = Absinthe.run!(query, Schema)

      filtered_tag_ids = Enum.map(filtered_tags, & &1["id"])
      assert [id_1, id_2, id_3] == filtered_tag_ids
    end
  end
end

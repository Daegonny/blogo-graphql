defmodule BlogoWeb.Graphql.Queries.PostTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.Post
  alias BlogoWeb.Graphql.Schema

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
  end
end

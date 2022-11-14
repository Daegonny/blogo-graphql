defmodule Blogo.PostsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.{Post, Posts}

  describe "get/1" do
    test "returns existing post" do
      post = insert(:post)
      loaded_post = Posts.get(post.id)
      assert loaded_post == post
    end

    test "returns nil when post does not exists" do
      nonexistent_id = Ecto.UUID.generate()
      assert Posts.get(nonexistent_id) == nil
    end
  end

  describe "all/0" do
    test "returns all existing posts" do
      posts = insert_list(5, :post) |> MapSet.new()
      loaded_posts = Posts.all() |> MapSet.new()
      assert MapSet.equal?(loaded_posts, posts)
    end

    test "returns empty list when there is no posts" do
      assert [] = Posts.all()
    end
  end

  describe "all/1" do
    test "returns posts limited by quantity" do
      limit = 3
      insert_list(5, :post)
      limited_posts = Posts.all(%{limit: limit})
      assert Enum.count(limited_posts) == limit
    end

    test "returns posts sorted by title" do
      %Post{id: id_3} = insert(:post, title: "C")
      %Post{id: id_2} = insert(:post, title: "B")
      %Post{id: id_1} = insert(:post, title: "A")

      sorted_posts = Posts.all(%{sort_by: [%{field: :title, order: :asc}]})
      sorted_posts_ids = Enum.map(sorted_posts, & &1.id)
      assert [id_1, id_2, id_3] == sorted_posts_ids
    end

    test "returns posts sorted by content" do
      %Post{id: id_3} = insert(:post, content: "C")
      %Post{id: id_2} = insert(:post, content: "B")
      %Post{id: id_1} = insert(:post, content: "A")

      loaded_posts = Posts.all(%{sort_by: [%{field: :content, order: :asc}]})
      loaded_post_ids = Enum.map(loaded_posts, & &1.id)
      assert [id_1, id_2, id_3] == loaded_post_ids
    end

    test "returns posts sorted by views" do
      %Post{id: id_3} = insert(:post, views: 3)
      %Post{id: id_2} = insert(:post, views: 2)
      %Post{id: id_1} = insert(:post, views: 1)

      loaded_posts = Posts.all(%{sort_by: [%{field: :views, order: :asc}]})
      loaded_post_ids = Enum.map(loaded_posts, & &1.id)
      assert [id_1, id_2, id_3] == loaded_post_ids
    end

    test "returns posts sorted by inserted_at" do
      %Post{id: id_1} = insert(:post, inserted_at: "2000-01-01 00:00:03")
      %Post{id: id_2} = insert(:post, inserted_at: "2000-01-01 00:00:02")
      %Post{id: id_3} = insert(:post, inserted_at: "2000-01-01 00:00:01")

      sorted_posts = Posts.all(%{sort_by: [%{field: :inserted_at, order: :desc}]})
      sorted_posts_ids = Enum.map(sorted_posts, & &1.id)
      assert [id_1, id_2, id_3] == sorted_posts_ids
    end

    test "returns posts filtered by text_search" do
      %Post{id: id_1} = insert(:post, title: "Um Queijo prato")
      %Post{id: id_2} = insert(:post, title: "ali havia queijo")
      insert(:post, title: "apenas sem lactose")
      %Post{id: id_4} = insert(:post, content: "QUEIJO gorgonzola")

      filtered_posts = Posts.all(%{filters: %{text_search: "queijo"}})
      filtered_post_ids = Enum.map(filtered_posts, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_1, id_2, id_4])

      assert MapSet.equal?(ids, filtered_post_ids)
    end

    test "returns posts filtered by min_views and max_views range" do
      insert(:post, views: 1)
      %Post{id: id_2} = insert(:post, views: 2)
      %Post{id: id_3} = insert(:post, views: 3)
      insert(:post, views: 4)

      filtered_posts = Posts.all(%{filters: %{min_views: 2, max_views: 3}})
      filtered_post_ids = Enum.map(filtered_posts, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_2, id_3])

      assert MapSet.equal?(ids, filtered_post_ids)
    end

    test "returns posts filtered by min_inserted_at and max_inserted_at range" do
      insert(:post, inserted_at: "2000-01-01 00:00:01")
      %Post{id: id_2} = insert(:post, inserted_at: "2000-01-01 00:00:02")
      %Post{id: id_3} = insert(:post, inserted_at: "2000-01-01 00:00:03")
      insert(:post, inserted_at: "2000-01-01 00:00:04")

      filtered_posts =
        Posts.all(%{
          filters: %{
            min_inserted_at: "2000-01-01 00:00:02",
            max_inserted_at: "2000-01-01 00:00:03"
          }
        })

      filtered_post_ids = Enum.map(filtered_posts, & &1.id) |> MapSet.new()
      ids = MapSet.new([id_2, id_3])

      assert MapSet.equal?(ids, filtered_post_ids)
    end

    test "applies limit, sort_by and filter simultaneously" do
      %Post{id: id_2} = insert(:post, title: "B letra")
      %Post{id: id_3} = insert(:post, title: "C letra")
      %Post{id: id_1} = insert(:post, title: "A letra")
      insert(:post, title: "D letra")
      insert(:post, title: "1 numero")

      filtered_posts =
        Posts.all(%{
          limit: 3,
          filters: %{text_search: "letra"},
          sort_by: [%{field: :title, order: :asc}]
        })

      filtered_post_ids = Enum.map(filtered_posts, & &1.id)
      assert [id_1, id_2, id_3] == filtered_post_ids
    end
  end
end

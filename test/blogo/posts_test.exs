defmodule Blogo.PostsTest do
  @moduledoc false

  use Blogo.DataCase, async: true
  import Blogo.Support.Factory
  alias Blogo.Posts

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
end

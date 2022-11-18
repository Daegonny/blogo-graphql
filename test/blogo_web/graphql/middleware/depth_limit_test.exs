defmodule BlogoWeb.Graphql.Middleware.DepthLimitTest do
  @moduledoc false
  use Blogo.DataCase, async: true
  alias BlogoWeb.Graphql.Schema

  describe "DepthLimit.call/2" do
    test "returns error when query depth exceeded the limit" do
      query = """
      query {
        tags {
          id
          posts {
            id
            authors {
              id
              tags {
                id
                posts {
                  id
                  authors {
                    id
                  }
                }
              }
            }
          }
        }
      }
      """

      assert %{
               errors: [
                 %{
                   code: :query_depth_limit_exceeded,
                   message: "Query depth limit has been exceeded",
                   status_code: 400
                 }
               ]
             } = Absinthe.run!(query, Schema)
    end
  end
end

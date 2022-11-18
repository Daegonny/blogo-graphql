defmodule BlogoWeb.Graphql.SchemaTests do
  @moduledoc false
  use Blogo.DataCase, async: true
  alias BlogoWeb.Graphql.Schema

  test "returns error when query complexity exceeded the limit" do
    query = """
    query {
     authors{
      id
      name
      age
      country
      insertedAt
     }
     posts{
      id
      title
      content
      views
      insertedAt
     }
     tags{
      id
      name
     }
     authors{
      id
      name
      age
      country
      insertedAt
     }
     posts{
      id
      title
      content
      views
      insertedAt
     }
    }
    """

    assert %{
             errors: [
               %{
                 message: message
               }
             ]
           } =
             Absinthe.run!(query, Schema,
               analyze_complexity: true,
               max_complexity: Application.fetch_env!(:blogo, :query_complexity_limit)
             )

    assert message =~ "Operation is too complex"
  end
end

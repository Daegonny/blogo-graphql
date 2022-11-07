defmodule Blogo.Support.Factory do
  @moduledoc """
  Factories for help testing
  """
  use ExMachina.Ecto, repo: Blogo.Repo
  alias Faker.{Address, Person}
  alias Blogo.{Author}

  def author_factory do
    %Author{
      name: Person.PtBr.name(),
      age: Faker.random_between(12, 100),
      country: Address.PtBr.country()
    }
  end
end

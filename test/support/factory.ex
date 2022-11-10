defmodule Blogo.Support.Factory do
  @moduledoc """
  Factories for help testing
  """
  use ExMachina.Ecto, repo: Blogo.Repo
  alias Faker.{Address, Lorem, Person}
  alias Blogo.{Author, Post, Tag}

  @spec author_factory :: Blogo.Author.t()
  def author_factory do
    %Author{
      name: Person.PtBr.name(),
      age: Faker.random_between(12, 100),
      country: Address.PtBr.country()
    }
  end

  @spec post_factory :: Blogo.Post.t()
  def post_factory do
    %Post{
      title: Lorem.word(),
      content: Lorem.sentence(1..50),
      views: Faker.random_between(0, 1_000_000)
    }
  end

  @spec tag_factory :: Blogo.Tag.t()
  def tag_factory do
    %Tag{
      name: Lorem.word()
    }
  end
end

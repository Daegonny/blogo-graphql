# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Blogo.Repo.insert!(%Blogo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Blogo.{Author, Post, Repo, Tag}

author_1 =
  Repo.insert!(%Author{name: "Bill Bryson", age: 70, country: "EUA"}, on_conflict: :nothing)

author_2 =
  Repo.insert!(%Author{name: "Felipe Castilho", age: 36, country: "Brasil"}, on_conflict: :nothing)

author_3 =
  Repo.insert!(%Author{name: "Clarice Lispector", age: 57, country: "Brasil"},
    on_conflict: :nothing
  )

post_1 =
  Repo.insert!(
    %Post{
      title: "A hora da estrela",
      views: 50,
      content:
        "Maecenas finibus porttitor commodo. Phasellus eu scelerisque nunc, nec euismod est. In hac habitasse platea dictumst. Donec suscipit leo diam, eu pretium est eleifend eu. In eu faucibus elit, at posuere mauris. In vestibulum mattis mauris, eu vestibulum arcu porttitor at. In vitae ante rutrum, pretium mi in, tincidunt arcu. Sed vel ante nibh. Donec fringilla pharetra porttitor. Aliquam ornare, erat non mattis lacinia, neque tortor gravida sem, vel imperdiet purus nisl at libero. Pellentesque eget elit vitae augue malesuada egestas."
    },
    on_conflict: :nothing
  )

post_2 =
  Repo.insert!(
    %Post{
      title: "Felicidade Clandestina",
      views: 32,
      content:
        "Duis eu sagittis elit. Praesent vel pretium felis. Ut suscipit turpis et urna sollicitudin lacinia. Etiam ut consequat nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed magna tortor, fermentum eget vehicula non, cursus eget lorem. Ut id justo libero."
    },
    on_conflict: :nothing
  )

post_3 =
  Repo.insert!(
    %Post{
      title: "Breve Historia de quase tudo",
      views: 23,
      content:
        "Donec pretium sem facilisis dolor tincidunt ornare. Donec leo tellus, convallis a nibh eleifend, auctor sagittis urna. Vestibulum suscipit mattis ultricies. Nunc ullamcorper risus sit amet risus bibendum vulputate."
    },
    on_conflict: :nothing
  )

post_4 =
  Repo.insert!(
    %Post{
      title: "O Legado do Folclore",
      views: 38,
      content:
        "Suspendisse et magna sapien. Nunc eget tempus quam. Mauris porttitor in quam id mattis. Maecenas fermentum lacus odio, vitae hendrerit enim gravida quis. Proin gravida tincidunt nunc ut bibendum. Sed eleifend ante tellus, sodales suscipit lorem efficitur non."
    },
    on_conflict: :nothing
  )

post_5 =
  Repo.insert!(
    %Post{
      title: "Serpentario",
      views: 15,
      content:
        "Sed vel ante nibh. Donec fringilla pharetra porttitor. Aliquam ornare, erat non mattis lacinia, neque tortor gravida sem, vel imperdiet purus nisl at libero. Pellentesque eget elit vitae augue malesuada egestas."
    },
    on_conflict: :nothing
  )

tag_1 =
  Repo.insert!(%Tag{name: "ficcao"},
    on_conflict: :nothing
  )

tag_2 =
  Repo.insert!(%Tag{name: "romance"},
    on_conflict: :nothing
  )

tag_3 =
  Repo.insert!(%Tag{name: "estrangeiro"},
    on_conflict: :nothing
  )

tag_4 =
  Repo.insert!(%Tag{name: "nao_ficcao"},
    on_conflict: :nothing
  )

tag_5 =
  Repo.insert!(%Tag{name: "fantasia"},
    on_conflict: :nothing
  )

{5, _} =
  Repo.insert_all("authors_posts", [
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Bryson
      author_id: Ecto.UUID.dump!(author_1.id),
      # Breve Historia
      post_id: Ecto.UUID.dump!(post_3.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Castilho
      author_id: Ecto.UUID.dump!(author_2.id),
      # Legado folclore
      post_id: Ecto.UUID.dump!(post_4.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Castilho
      author_id: Ecto.UUID.dump!(author_2.id),
      # Serpentario
      post_id: Ecto.UUID.dump!(post_5.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Lispector
      author_id: Ecto.UUID.dump!(author_3.id),
      # Estrela
      post_id: Ecto.UUID.dump!(post_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Lispector
      author_id: Ecto.UUID.dump!(author_3.id),
      # Felicidade
      post_id: Ecto.UUID.dump!(post_2.id)
    }
  ])

{6, _} =
  Repo.insert_all("authors_tags", [
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Bryson
      author_id: Ecto.UUID.dump!(author_1.id),
      # Nao Ficcao
      tag_id: Ecto.UUID.dump!(tag_3.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Bryson
      author_id: Ecto.UUID.dump!(author_1.id),
      # estrangeiro
      tag_id: Ecto.UUID.dump!(tag_4.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Castilho
      author_id: Ecto.UUID.dump!(author_2.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Castilho
      author_id: Ecto.UUID.dump!(author_2.id),
      # Fantasia
      tag_id: Ecto.UUID.dump!(tag_5.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Lispector
      author_id: Ecto.UUID.dump!(author_3.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Lispector
      author_id: Ecto.UUID.dump!(author_3.id),
      # Romance
      tag_id: Ecto.UUID.dump!(tag_2.id)
    }
  ])

{10, _} =
  Repo.insert_all("posts_tags", [
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Estrela
      post_id: Ecto.UUID.dump!(post_1.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Estrela
      post_id: Ecto.UUID.dump!(post_1.id),
      # Romance
      tag_id: Ecto.UUID.dump!(tag_2.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Felicidade
      post_id: Ecto.UUID.dump!(post_2.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Felicidade
      post_id: Ecto.UUID.dump!(post_2.id),
      # Romance
      tag_id: Ecto.UUID.dump!(tag_2.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Breve Historia
      post_id: Ecto.UUID.dump!(post_3.id),
      # estrangeiro
      tag_id: Ecto.UUID.dump!(tag_3.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Breve Historia
      post_id: Ecto.UUID.dump!(post_3.id),
      # Nao Ficcao
      tag_id: Ecto.UUID.dump!(tag_4.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Legado Folclore
      post_id: Ecto.UUID.dump!(post_4.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Legado Folclore
      post_id: Ecto.UUID.dump!(post_4.id),
      # Fantasia
      tag_id: Ecto.UUID.dump!(tag_5.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Serpentario
      post_id: Ecto.UUID.dump!(post_5.id),
      # Ficcao
      tag_id: Ecto.UUID.dump!(tag_1.id)
    },
    %{
      id: Ecto.UUID.dump!(Ecto.UUID.generate()),
      # Serpentario
      post_id: Ecto.UUID.dump!(post_5.id),
      # Fantasia
      tag_id: Ecto.UUID.dump!(tag_5.id)
    }
  ])

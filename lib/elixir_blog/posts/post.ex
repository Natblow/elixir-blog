defmodule ElixirBlog.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias ElixirBlog.Accounts.User
  alias ElixirBlog.Comments.Comment

  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to(:user, User)
    has_many(:comments, Comment, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body, :user_id])
  end
end

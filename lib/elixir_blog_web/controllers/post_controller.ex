defmodule ElixirBlogWeb.PostController do
  use ElixirBlogWeb, :controller

  alias ElixirBlogWeb.Router.Helpers, as: Routes
  alias ElixirBlog.Repo
  alias ElixirBlog.Posts
  alias ElixirBlog.Posts.Post
  alias ElixirBlog.Comments.Comment

  def index(conn, _params) do
    posts =
      Posts.list_posts()
      |> Repo.preload([:user])

    render(conn, :index, posts: posts)
  end

  def new(conn, _params) do
    current_user = conn.assigns.current_user
    changeset = Posts.change_post(%Post{user_id: current_user.id})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user
    post_params = Map.put(post_params, "user_id", current_user.id)

    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def add_comment(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    post =
      post_id
      |> Posts.get_post!()
      |> Repo.preload([:comments])

    case Posts.add_comment(post_id, comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment added successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))
      {:error, _error} ->
        conn
        |> put_flash(:error, "Comment could not be added.")
        |> redirect(to: Routes.post_path(conn, :show, post))
    end
  end

  def show(conn, %{"id" => id}) do
    post =
      id
      |> Posts.get_post!()
      |> Repo.preload([:comments])

    changeset = Comment.changeset(%Comment{}, %{})
    render(conn, :show, post: post, comments: post.comments, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    changeset = Posts.change_post(post)
    render(conn, :edit, post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id)

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: ~p"/posts/#{post}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id)
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: ~p"/posts")
  end
end

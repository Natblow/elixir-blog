defmodule ElixirBlog.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ElixirBlog.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        content: "some content",
        name: "some name"
      })
      |> ElixirBlog.Comments.create_comment()

    comment
  end
end

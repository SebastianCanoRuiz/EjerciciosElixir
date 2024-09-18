defmodule Library do
  @moduledoc """
  A module for managing a library system with books and users.
  """

  defmodule Book do
    @moduledoc """
    A struct representing a book in the library.
    """
    defstruct title: "", author: "", isbn: "", available: true
  end

  defmodule User do
    @moduledoc """
    A struct representing a user of the library.
    """
    defstruct name: "", id: "", borrowed_books: []
  end

  @doc """
  Adds a book to the library.

  ## Parameters
  - library: The current list of books in the library.
  - book: The book struct to add.

  ## Examples

      iex> library = []
      iex> book = %Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}
      iex> Library.add_book(library, book)
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}]
  """
  def add_book(library, %Book{} = book) do
    library ++ [book]
  end

  @doc """
  Adds a user to the library system.

  ## Parameters
  - users: The current list of users.
  - user: The user struct to add.

  ## Examples

      iex> users = []
      iex> user = %Library.User{name: "Alice", id: "1"}
      iex> Library.add_user(users, user)
      [%Library.User{name: "Alice", id: "1", borrowed_books: []}]
  """
  def add_user(users, %User{} = user) do
    users ++ [user]
  end

  @doc """
  Allows a user to borrow a book from the library.

  ## Parameters
  - library: The current list of books in the library.
  - users: The current list of users.
  - user_id: The ID of the user borrowing the book.
  - isbn: The ISBN of the book to borrow.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}]
      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: []}]
      iex> Library.borrow_book(library, users, "1", "1234567890")
      {:ok, [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}], [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]}]}
  """
  def borrow_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(library, &(&1.isbn == isbn && &1.available))

    cond do
      user == nil -> {:error, "Usuario no encontrado"}
      book == nil -> {:error, "Libro no disponible"}
      true ->
        updated_book = %{book | available: false}
        updated_user = %{user | borrowed_books: user.borrowed_books ++ [updated_book]}

        updated_library = Enum.map(library, fn
          b when b.isbn == isbn -> updated_book
          b -> b
        end)

        updated_users = Enum.map(users, fn
          u when u.id == user_id -> updated_user
          u -> u
        end)

        {:ok, updated_library, updated_users}
    end
  end

  @doc """
  Allows a user to return a borrowed book to the library.

  ## Parameters
  - library: The current list of books in the library.
  - users: The current list of users.
  - user_id: The ID of the user returning the book.
  - isbn: The ISBN of the book to return.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]
      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: false}]}]
      iex> Library.return_book(library, users, "1", "1234567890")
      {:ok, [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}], [%Library.User{name: "Alice", id: "1", borrowed_books: []}]}
  """
  def return_book(library, users, user_id, isbn) do
    user = Enum.find(users, &(&1.id == user_id))
    book = Enum.find(user.borrowed_books, &(&1.isbn == isbn))

    cond do
      user == nil -> {:error, "Usuario no encontrado"}
      book == nil -> {:error, "Libro no encontrado en los libros prestados del usuario"}
      true ->
        updated_book = %{book | available: true}
        updated_user = %{user | borrowed_books: Enum.filter(user.borrowed_books, &(&1.isbn != isbn))}

        updated_library = Enum.map(library, fn
          b when b.isbn == isbn -> updated_book
          b -> b
        end)

        updated_users = Enum.map(users, fn
          u when u.id == user_id -> updated_user
          u -> u
        end)

        {:ok, updated_library, updated_users}
    end
  end

  @doc """
  Lists all books in the library.

  ## Parameters
  - library: The current list of books in the library.

  ## Examples

      iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
      iex> Library.list_books(library)
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
  """
  def list_books(library) do
    library
  end

  @doc """
  Lists all users in the library system.

  ## Parameters
  - users: The current list of users.

  ## Examples

      iex> users = [%Library.User{name: "Alice", id: "1"}]
      iex> Library.list_users(users)
      [%Library.User{name: "Alice", id: "1"}]
  """
  def list_users(users) do
    users
  end

  @doc """
  Lists all books borrowed by a specific user.

  ## Parameters
  - users: The current list of users.
  - user_id: The ID of the user whose borrowed books are to be listed.

  ## Examples

      iex> users = [%Library.User{name: "Alice", id: "1", borrowed_books: [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]}]
      iex> Library.books_borrowed_by_user(users, "1")
      [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890"}]
  """
  def books_borrowed_by_user(users, user_id) do
    user = Enum.find(users, &(&1.id == user_id))
    if user, do: user.borrowed_books, else: []
  end



@doc """
Busca libros por título o autor y muestra los resultados con la disponibilidad.

## Parameters
- library: La lista actual de libros en la biblioteca.
- argument: El término de búsqueda (parte del título o autor).

## Ejemplos

    iex> library = [%Library.Book{title: "Elixir in Action", author: "Saša Jurić", isbn: "1234567890", available: true}]
    iex> Library.search_books(library, "Elixir")
    Libro disponible: "Elixir in Action" por Saša Jurić
"""
  def search_books(library, argument) do
    results = Enum.filter(library,

    # &(String.contains?(&1.title, argument)
    # or
    # String.contains?(&1.author, argument)))
    fn book ->
      String.contains?(book.title, argument)
      or
      String.contains?(book.author, argument)
    end)

    Enum.each(results, fn book ->
      if book.available do
        IO.puts("Libro disponible: #{book.title} por #{book.author}")
      else
        IO.puts("Libro no disponible: #{book.title} por #{book.author}")
      end
    end)
  end

@doc """
Cuenta el número de libros disponibles en la biblioteca.

## Parameters
- library: La lista actual de libros en la biblioteca.

## Ejemplos

    iex> library = [%Library.Book{available: true}, %Library.Book{available: false}]
    iex> Library.count_available_books(library)
    1
"""
def count_available_books(library) do
  Enum.count(library, & &1.available)
end


end

defmodule Reader do
  @moduledoc """
  This module provides functions for reading Employee data from a JSON file.

  ## Special Symbols
  - `defmodule`: Defines a new module
  - `@moduledoc`: Provides documentation for the module
  """

  alias Empresa.Employee

  @doc """
  Reads all employees from the JSON file.

  ## Parameters
  - `filename`: String, the name of the JSON file to read from (optional, default: "employees.json")

  ## Returns
  - List of Employee structs

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `def`: Defines a public function
  - `\\\\`: Default argument separator
  - `case`: Pattern matches on the result of an expression
  - `|>`: The pipe operator

  ## Examples
      iex> Reader.read_all_employees()
      [%Empresa.Employee{...}, ...]
  """
  @spec read_all_employees(String.t()) :: [Employee.t()]
  def read_all_employees(filename \\ "employees.json") do
    case File.read(filename) do
      {:ok, contents} ->
        # Example of how Jason.decode! works:
        # If contents = '{"name": "John", "age": 30}'
        # Jason.decode!(contents, keys: :atoms) returns:
        # %{name: "John", age: 30}
        Jason.decode!(contents, keys: :atoms)
        |> Enum.map(&struct(Employee, &1))
      {:error, :enoent} -> []
    end
  end

  @doc """
  Reads an employee by their ID from the JSON file.

  ## Parameters
  - `id`: Integer, the ID of the employee to find
  - `filename`: String, the name of the JSON file to read from (optional, default: "employees.json")

  ## Returns
  - `{:ok, Employee.t()}` if the employee is found
  - `{:error, :not_found}` if the employee is not found

  ## Special Symbols
  - `@doc`: Provides documentation for the function
  - `@spec`: Specifies the function's type specification
  - `def`: Defines a public function
  - `\\\\`: Default argument separator
  - `case`: Pattern matches on the result of an expression
  - `&`: Creates an anonymous function
  - `&1`: Refers to the first argument of the anonymous function

  ## Examples
      iex> Reader.read_employee_by_id(1)
      {:ok, %Empresa.Employee{id: 1, ...}}

      iex> Reader.read_employee_by_id(999)
      {:error, :not_found}
  """
  @spec read_employee_by_id(integer(), String.t()) :: {:ok, Employee.t()} | {:error, :not_found}
  def read_employee_by_id(id, filename \\ "employees.json") do
    employees = read_all_employees(filename)

    case Enum.find(employees, &(&1.id == id)) do
      nil -> {:error, :not_found}
      employee -> {:ok, employee}
    end
  end
end


#  ***************  Función agregada  *********************


@doc """
Filters employees by their position.

## Parameters
- `position`: The position to filter employees by.
- `filename`: The file where the employees are stored.

## Returns
- A list of `%Employee{}` structs that match the given position.

## Examples
    iex> Reader.filter_by_position("Manager", "employees.json")
    [%Employee{position: "Manager", ...}, %Employee{position: "Manager", ...}]
"""
def filter_by_position(position, filename) do
  employees = read_employees(filename)
  Enum.filter(employees, fn employee -> employee.position == position end)
end

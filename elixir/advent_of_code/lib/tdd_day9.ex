defmodule TDDEncodingError do
  def get_numbers_to_check(numbers, preamble) do
    numbers
    |> Enum.slice(preamble, length(numbers) - preamble)
  end

  def get_numbers_in_preamble(numbers, index, preamble) do
    numbers
    |> Enum.slice(index - preamble, preamble)
  end

  def get_diff_with_each_preamble_number(numbers, index, preamble) do
    get_numbers_in_preamble(numbers, index, preamble)
    |> Enum.map(&(Enum.at(numbers, index) - &1))
  end

  def get_invalid_number(numbers, preamble) when preamble >= length(numbers),
    do: {:error, "Preamble must be lower tnat the numbers length"}

  def get_invalid_number(numbers, preamble) do
    numbers
    |> Enum.with_index()
q    |> Enum.reduce_while(0, fn {number, index}, _acc ->
      differences = get_diff_with_each_preamble_number(numbers, index, preamble)
      no_matches = get_numbers_in_preamble(numbers, index, preamble) -- differences
      if length(no_matches) == length(differences), do: {:halt, number}, else: {:cont, nil}
    end)
  end
end

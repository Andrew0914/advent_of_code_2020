defmodule TDDEncodingError do
  def get_invalid_number(numbers, preamble) do
    numbers
    |> Enum.with_index()
    |> get_numbers_to_check(preamble)
    |> Enum.reduce_while(0, fn {number, index}, _acc ->
      preamble_numbers = numbers |> get_numbers_in_preamble(index, preamble)
      matches = preamble_numbers -- get_diff_with_each_preamble_number(number, preamble_numbers)
      if length(matches) == length(differences), do: {:halt, number}, else: {:cont, nil}
    end)
  end
end

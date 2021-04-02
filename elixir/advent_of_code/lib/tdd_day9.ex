defmodule TDDEncodingError do
  # PART 1
  def get_numbers_to_check(numbers, preamble) do
    numbers
    |> Enum.slice(preamble, length(numbers) - preamble)
  end

  def get_numbers_in_preamble(numbers, index, preamble) do
    numbers
    |> Enum.slice(index - preamble, preamble)
  end

  def get_invalid_number(numbers, preamble) when preamble >= length(numbers),
    do: {:error, "Preamble must be lower tnat the numbers length"}

  def get_invalid_number(numbers, preamble) do
    numbers
    |> Enum.with_index()
    |> get_numbers_to_check(preamble)
    |> Enum.reduce_while(0, fn {number, index}, _acc ->
      numbers_in_preamble = get_numbers_in_preamble(numbers, index, preamble)
      differences = numbers_in_preamble |> Enum.map(&(number - &1))

      no_matches = numbers_in_preamble -- differences

      if length(no_matches) == length(differences),
        do: {:halt, {number, index}},
        else: {:cont, nil}
    end)
  end

  def get_numbers(content) do
    content
    |> String.split(~r/\r\n|\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn str_number ->
      {number, _} = Integer.parse(str_number)
      number
    end)
  end

  # PART 2
  def get_contiguos_numbers_that_sum({sum, sum_index}, numbers, preamble, index \\ 0) do
    numbers_to_check =
      numbers
      |> Enum.slice(0, sum_index)

    {status, contiguous_numbers} =
      numbers_to_check
      |> Enum.slice(index, length(numbers) - 1)
      |> Enum.reduce_while({[], 0}, fn number, acc ->
        {last_numbers, last_sum} = acc
        acc = {last_numbers ++ [number], last_sum + number}

        cond do
          last_sum + number == sum -> {:halt, {:fit, elem(acc, 0)}}
          last_sum + number < sum -> {:cont, acc}
          last_sum + number > sum -> {:halt, {:overflow, elem(acc, 0)}}
        end
      end)

    case status do
      :fit ->
        contiguous_numbers

      _ ->
        if index + 1 >= length(numbers_to_check),
          do: {:error, "It could not find numbers"},
          else: get_contiguos_numbers_that_sum({sum, sum_index}, numbers, preamble, index + 1)
    end
  end

  def sum_min_max(numbers) do
    {min, max} = Enum.min_max(numbers)
    min + max
  end
end

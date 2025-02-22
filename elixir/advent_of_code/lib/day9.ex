defmodule EncodingError do
  @file_name "./number_series.txt"

  defp get_numbers_series() do
    File.read!(@file_name)
  end

  defp parse_numbers(content) do
    content
    |> String.split(~r/\r\n|\n/)
    |> Enum.map(fn str_number ->
      {number, _} = Integer.parse(str_number)
      number
    end)
    |> Enum.with_index()
  end

  defp find_factors(numbers_in_preamble, {number, minuend}) do
    possible_substracting = number - minuend

    substracring =
      numbers_in_preamble
      |> Enum.find(fn {subs, _index} ->
        subs != minuend and subs == possible_substracting
      end)

    {substracring, minuend}
  end

  defp are_there_sum_factors(numbers_in_preamble, {number, index}) do
    numbers_in_preamble
    |> Enum.reduce_while(0, fn {minuend, _index}, _acc ->
      {substracting, _minuend} = find_factors(numbers_in_preamble, {number, minuend})

      if substracting != nil,
        do: {:halt, true},
        else: {:cont, false}
    end)
  end

  defp find_invalid_number(all_numbers, preamble) when preamble >= length(all_numbers),
    do: {:error, "preamble is higher than list numbers length"}

  defp find_invalid_number(all_numbers, preamble) do
    all_numbers
    |> Enum.slice(preamble, length(all_numbers) - 1)
    |> Enum.reduce_while(0, fn number_with_index, _acc ->
      {number, index} = number_with_index

      numbers_in_preamble = Enum.slice(all_numbers, index - preamble, preamble)

      if are_there_sum_factors(numbers_in_preamble, {number, index}),
        do: {:cont, nil},
        else: {:halt, number}
    end)
  end

  def get_invalid_number(preamble) do
    get_numbers_series()
    |> parse_numbers()
    |> find_invalid_number(preamble)
  end

  #  --- PART 2 ---

  defp find_numbers_that_sum(sum, all_numbers, start_index)
       when start_index >= length(all_numbers),
       do: {:error, "It couldn't found weakness correctly"}

  defp find_numbers_that_sum(sum, all_numbers, start_index \\ 0) do
    possible_weakness =
      all_numbers
      |> Enum.slice(start_index, length(all_numbers) - start_index)
      |> Enum.reduce_while({[], 0}, fn {number, index}, acc ->
        {contiguous_numbers, summation} = acc
        new_summation = summation + number
        acc = {contiguous_numbers ++ [number], new_summation}

        cond do
          new_summation < sum -> {:cont, acc}
          new_summation > sum -> {:halt, {:exceeded, acc}}
          new_summation == sum -> {:halt, {:founded, acc}}
        end
      end)

    if(is_tuple(possible_weakness) and elem(possible_weakness, 0) == :founded) do
      possible_weakness
    else
      find_numbers_that_sum(sum, all_numbers, start_index + 1)
    end
  end

  def find_encryptation_weakness(sum) do
    all_numbers =
      get_numbers_series()
      |> parse_numbers()

    case find_numbers_that_sum(sum, all_numbers, 0) do
      {:founded, {contiguous_numbers, _summation}} ->
        sorted_numbers = Enum.sort(contiguous_numbers)

        Enum.at(sorted_numbers, 0) + Enum.at(sorted_numbers, length(sorted_numbers) - 1)

      {:error, message} ->
        {:error, message}
    end
  end
end

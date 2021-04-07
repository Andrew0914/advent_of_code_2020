defmodule AdapterArray do
  def get_adapters(adapaters_file_content) do
    adapaters_file_content
    |> String.split(~r/\r\n|\n/, trim: true)
    |> Enum.map(fn adapter ->
      {jolt, _} = Integer.parse(adapter)
      jolt
    end)
    |> Enum.sort()
    |> Enum.with_index()
  end

  def add_first_and_last_adaptaers(adapters, initial_adapter) do
    current_adapters =
      adapters
      |> Enum.map(fn adapter ->
        {jolts, _} = adapter
        jolts
      end)

    last_adapter_jolts = Enum.at(current_adapters, length(current_adapters) - 1)

    ([0] ++ current_adapters ++ [last_adapter_jolts + 3])
    |> Enum.with_index()
  end

  def get_adapters_difference(adapter_one, adapter_two) do
    if adapter_two == nil do
      nil
    else
      {jolts_one, _} = adapter_one
      {jolts_two, _} = adapter_two
      jolts_two - jolts_one
    end
  end

  def get_differences_counters(jolts_list, initial_jolts) do
    all_adapters =
      jolts_list
      |> add_first_and_last_adaptaers(initial_jolts)

    all_adapters
    |> Enum.reduce({0, 0, 0}, fn {jolts, index}, acc ->
      {one, two, three} = acc
      difference = get_adapters_difference({jolts, index}, Enum.at(all_adapters, index + 1))

      case difference do
        1 -> {one + 1, 0, three}
        2 -> {one, 0, three}
        3 -> {one, 0, three + 1}
        nil -> {one, two, three}
      end
    end)
  end

  def part_1_solution(file_path) do
    {one, two, three} =
      File.read!(file_path)
      |> get_adapters()
      |> get_differences_counters(0)

    one * three
  end

  # Part2
  def get_combinations(adapters, adapter_to_connect) do
    adapters
    |> Enum.reduce(0, fn {jolts, index}, acc ->
      difference = jolts - adapter_to_connect
      if difference >= 1 and difference <= 3, do: acc + 1, else: acc
    end)
  end

  def get_all_combinations(adapters) do
    all_adapters =
      adapters
      |> add_first_and_last_adaptaers(0)

    all_adapters
    |> Enum.reduce(0, fn {jolts, index}, acc ->
      acc + get_combinations(all_adapters, jolts)
    end)
  end
end

defmodule PassportProcessing do
  defp get_passports_file_content(file_path) do
    File.read!(file_path)
  end

  defp required_keys() do
    [
      "byr",
      "iyr",
      "eyr",
      "hgt",
      "hcl",
      "ecl",
      "pid"
    ]
  end

  defp parse_passport_content(passport) do
    passport
    |> String.split("\n")
    |> Enum.map(fn passport_line -> String.split(passport_line, " ") end)
    |> Enum.flat_map(fn passport_fields -> passport_fields end)
  end

  defp parse_passport_fields(passport_content) do
    passport_content
    |> Enum.reduce(%{}, fn p, acc ->
      [key, value] = String.split(p, ":")
      Map.put(acc, key, value)
    end)
  end

  defp get_passports(content) do
    content
    |> String.split("\n\n")
    |> Enum.map(fn passport -> parse_passport_content(passport) end)
    |> Enum.map(fn passport_content -> parse_passport_fields(passport_content) end)
  end

  defp validate_required_fields(passport_map) do
    required_keys()
    |> Enum.all?(fn key -> Enum.member?(Map.keys(passport_map), key) end)
  end

  def day_4_part_1_solution(file_path) do
    get_passports_file_content(file_path)
    |> get_passports()
    |> Enum.count(fn passport -> validate_required_fields(passport) end)
  end
end

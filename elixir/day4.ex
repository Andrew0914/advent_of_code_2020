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

  defp validate_year(passport, year_field, lowest, higest) do
    if String.match?(passport[year_field], ~r/^[0-9]{4}$/) do
      {year, _} =
        passport[year_field]
        |> String.trim()
        |> Integer.parse()

      year >= lowest and year <= higest
    else
      false
    end
  end

  defp validate_hair_color(passport) do
    String.match?(passport["hcl"], ~r/^#[0-9a-f]{6}$/)
  end

  defp validate_eye_color(passport) do
    String.match?(passport["ecl"], ~r/^(amb|blu|brn|gry|grn|hzl|oth)$/)
  end

  def validate_passport_id(passport) do
    String.match?(passport["pid"], ~r/^[0-9]{9}$/)
  end

  defp validate_height(passport) do
    if String.match?(passport["hgt"], ~r/^[0-9]+(cm|in)$/) do
      [str_number, _] = String.split(passport["hgt"], ~r/(cm|in)$/)
      {number, _} = Integer.parse(str_number)

      cond do
        String.contains?(passport["hgt"], "cm") -> number >= 150 and number <= 193
        String.contains?(passport["hgt"], "in") -> number >= 59 and number <= 76
      end
    else
      false
    end
  end

  defp deep_validate_passport(passport) do
    validate_required_fields(passport) and
      validate_year(passport, "byr", 1920, 2002) and
      validate_year(passport, "iyr", 2010, 2020) and
      validate_year(passport, "eyr", 2020, 2030) and
      validate_hair_color(passport) and
      validate_eye_color(passport) and
      validate_height(passport) and
      validate_passport_id(passport)
  end

  def day_4_part_1_solution(file_path) do
    get_passports_file_content(file_path)
    |> get_passports()
    |> Enum.count(fn passport -> validate_required_fields(passport) end)
  end

  def day_4_part_2_solution(file_path) do
    get_passports_file_content(file_path)
    |> get_passports()
    |> Enum.count(fn passport -> deep_validate_passport(passport) end)
  end
end

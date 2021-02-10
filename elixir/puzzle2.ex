defmodule Puzzle2 do
  def password_contracts() do
    File.read!("passwords.txt")
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, " ") end)
    |> Enum.map(fn str_contract -> format_contract(str_contract) end)
  end

  def format_contract(str_contract) do
    [str_minmax, str_letter, password] = str_contract
    [min, max] = String.split(str_minmax, "-")
    letter = String.replace(str_letter, ":", "")

    %{
      min: String.to_integer(min),
      max: String.to_integer(max),
      letter: letter,
      password: password
    }
  end

  def valid_passwords_count() do
    Enum.map(password_contracts, fn contract ->
      letter_count =
        contract[:password]
        |> String.graphemes()
        |> Enum.filter(fn char -> char == contract[:letter] end)
        |> length()

      letter_count >= contract[:min] and letter_count <= contract[:max]
    end)
    |> Enum.filter(fn valid -> valid end)
    |> length()
  end

  def valid_passwords_positions() do
    Enum.map(password_contracts, fn contract ->
      password_letters =
        contract[:password]
        |> String.graphemes()

      :erlang.xor(
        Enum.at(password_letters, contract[:min] - 1) == contract[:letter],
        Enum.at(password_letters, contract[:max] - 1) == contract[:letter]
      )
    end)
    |> Enum.filter(fn valid -> valid end)
    |> length()
  end
end

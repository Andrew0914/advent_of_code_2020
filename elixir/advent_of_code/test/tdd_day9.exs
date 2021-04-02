defmodule EncodingErrroTest do
  use ExUnit.Case

  test "The first number that is not follow the rules is found" do
    # Arrange
    numbers = [
      35,
      20,
      15,
      25,
      47,
      40,
      62,
      55,
      65,
      95,
      102,
      117,
      150,
      182,
      127,
      219,
      299,
      277,
      309,
      576
    ]

    preamble = 5
    # Act
    invalid_number = TDDEncodingError.get_invalid_number(numbers, preamble)
    # Assert
    assert invalid_number == 127
  end

  test "Get number to check after preamble" do
    # Arrange
    numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65]

    preamble = 5
    # Act
    numbers_to_check = TDDEncodingError.get_numbers_to_check(numbers, preamble)
    # Assert
    assert numbers_to_check == [40, 62, 55, 65]
  end

  test "Get numbers in preamble starting from index" do
    # Arrange
    numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65]
    index = 7
    preamble = 5
    # Act
    preamble_numbers = TDDEncodingError.get_numbers_in_preamble(numbers, index, preamble)
    # Assert
    assert preamble_numbers == [15, 25, 47, 40, 62]
  end

  test "Find differences between given number and each number in its preamble" do
    # Arrange
    numbers = [35, 20, 15, 25, 47, 40, 62, 55, 65]
    index_of_given_number = 7
    preamble = 3
    # Act
    differences = TDDEncodingError.get_diff_with_each_preamble_number(numbers, index_of_given_number, preamble)
    # Assert
    assert differences == [8, 15, -7]
  end
end

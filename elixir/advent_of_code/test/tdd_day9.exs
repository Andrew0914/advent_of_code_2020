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
end

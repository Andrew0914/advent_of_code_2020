defmodule AdapterArrayTest do
  use ExUnit.Case

  test "Get ordered jolts number with its index in a list from file content" do
    # Arrange
    jolts_file_content = """
    6
    12
    4
    """

    expected_adapters = [{4, 0}, {6, 1}, {12, 2}]
    # Act
    adapters = AdapterArray.get_adapters(jolts_file_content)
    # Assert
    assert adapters == expected_adapters
  end

  test "There is the built-in adapter and the end of the adapters list" do
    # Arrange
    jolts_list = [
      {1, 0},
      {4, 1},
      {5, 2}
    ]

    expected_adapters = [
      {0, 0},
      {1, 1},
      {4, 2},
      {5, 3},
      {8, 4}
    ]

    initial_jolts = 0
    # Act
    all_adapters = AdapterArray.add_first_and_last_adaptaers(jolts_list, initial_jolts)

    # Asset
    assert all_adapters == expected_adapters
  end

  test "Get the difference jolts from an dapter and the next inmediate " do
    # Arrange
    adapter_one = {10, 0}
    adapter_two = {12, 1}
    expected_difference = 2
    # Act
    difference = AdapterArray.get_adapters_difference(adapter_one, adapter_two)
    # Assert
    assert difference == expected_difference
  end

  test "Return null when there is no next inmediate adapter " do
    # Arrange
    adapter_one = {10, 0}
    adapter_two = nil
    expected_difference = nil
    # Act
    difference = AdapterArray.get_adapters_difference(adapter_one, adapter_two)
    # Assert
    assert difference == expected_difference
  end

  test "Count differences with 1 and 3 in the adapter chain" do
    # Arrange
    jolts_list = [
      {1, 0},
      {4, 1},
      {5, 2},
      {6, 3},
      {7, 4},
      {10, 5},
      {11, 6},
      {12, 7},
      {15, 8},
      {16, 9},
      {19, 10}
    ]

    expected_counters = {7, 0, 5}
    initial_jolts = 0
    # Act
    counters = AdapterArray.get_differences_counters(jolts_list, initial_jolts)
    # Assert
    assert counters == expected_counters
  end

  test "Get different combinations to connect one adapter with anothers in a list  with 1 and 3 jolts difference" do
    # Arrange
    adapters = [{1, 0}, {2, 1}, {3, 2}, {4, 3}, {5, 4}]
    adapter_to_connect = 1
    # Act
    combinations = AdapterArray.get_combinations(adapters, adapter_to_connect)
    # Assert
    assert combinations == 3
  end

  test "Get all posible adapters combinations" do
    # Arrange
    adapters = [
      {1, 0},
      {4, 1},
      {5, 2},
      {6, 3},
      {7, 4},
      {10, 5},
      {11, 6},
      {12, 7},
      {15, 8},
      {16, 9},
      {19, 10}
    ]

    # Act
    combinations = AdapterArray.get_all_combinations(adapters)

    # Asser
    assert combinations == 8

  end
end

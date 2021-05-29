defmodule NavigationSystemTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  test_with_params "Determine position after turning left",
    fn origin, degrees, expected ->
      assert NavigationSystem.where_does_it_turn(origin, "L", degrees) == expected
    end
    do
    [
      {"E", 90, "N"},
      {"E", 180, "W"},
      {"E", 270, "S"},
      {"W", 90, "S"},
      {"W", 180, "E"},
      {"W", 270, "N"},
      {"N", 90, "W"},
      {"N", 180, "S"},
      {"N", 270, "E"},
      {"S", 90, "E"},
      {"S", 180, "N"},
      {"S", 270, "W"}
    ]
  end

  test_with_params "Determine position after turning right",
    fn origin, degrees, expected ->
      assert NavigationSystem.where_does_it_turn(origin, "R", degrees) == expected
    end
    do
    [
      {"E", 90, "S"},
      {"E", 180, "W"},
      {"E", 270, "N"},
      {"W", 90, "N"},
      {"W", 180, "E"},
      {"W", 270, "S"},
      {"N", 90, "E"},
      {"N", 180, "S"},
      {"N", 270, "W"},
      {"S", 90, "W"},
      {"S", 180, "N"},
      {"S", 270, "E"}
    ]
  end

  # N S E W
  test_with_params "Move to certain cardinal point",
    fn current_points, cardinal_point, distance, expected ->
      assert NavigationSystem.do_instruction(
              current_points,
              cardinal_point,
              distance
            ) == expected
    end
    do
    [
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}, "E", 10,
       %{"E" => 35, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}},
      {%{"E" => 25, "W" => 20, "N" => 100, "S" => 90, "direction" => "E"}, "W", 20,
       %{"E" => 25, "W" => 40, "N" => 100, "S" => 90, "direction" => "E"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}, "N", 25,
       %{"E" => 25, "W" => 0, "N" => 125, "S" => 90, "direction" => "E"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}, "S", 30,
       %{"E" => 25, "W" => 0, "N" => 100, "S" => 120, "direction" => "E"}}
    ]
  end

  # R - L
  test_with_params "turn (update) the cardinal point we have to go",
    fn current_points, turn_direction, degrees, expected ->
      assert NavigationSystem.do_instruction(
              current_points,
              turn_direction,
              degrees
            ) == expected
    end
    do
    [
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}, "L", 90,
       %{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "N"}},
      {%{"E" => 25, "W" => 20, "N" => 100, "S" => 90, "direction" => "N"}, "R", 180,
       %{"E" => 25, "W" => 20, "N" => 100, "S" => 90, "direction" => "S"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "S"}, "L", 270,
       %{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "W"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "W"}, "R", 90,
       %{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "N"}}
    ]
  end

  test_with_params "Go forward to the right direction",
    fn current_points, go_forward, distance, expected ->
      assert NavigationSystem.do_instruction(
              current_points,
              go_forward,
              distance
            ) == expected
    end
    do
    [
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}, "F", 90,
       %{"E" => 115, "W" => 0, "N" => 100, "S" => 90, "direction" => "E"}},
      {%{"E" => 25, "W" => 20, "N" => 280, "S" => 90, "direction" => "N"}, "F", 180,
       %{"E" => 25, "W" => 20, "N" => 460, "S" => 90, "direction" => "N"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "S"}, "F", 270,
       %{"E" => 25, "W" => 0, "N" => 100, "S" => 360, "direction" => "S"}},
      {%{"E" => 25, "W" => 0, "N" => 100, "S" => 90, "direction" => "W"}, "F", 90,
       %{"E" => 25, "W" => 90, "N" => 100, "S" => 90, "direction" => "W"}}
    ]
  end

  test "Perform all instructions gets navigation info" do
    # Arrange
    instructions = [{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]

    initial_navigation = %{
      "E" => 0,
      "W" => 0,
      "N" => 0,
      "S" => 0,
      "direction" => "E"
    }

    expected_navigation = %{
      "E" => 17,
      "W" => 0,
      "N" => 3,
      "S" => 11,
      "direction" => "S"
    }

    # Act
    navigation = NavigationSystem.navigate(initial_navigation, instructions)

    # Assert
    assert navigation == expected_navigation
  end

  test "Calculate distance with navigation system" do
    # Arrange
    navigation = %{"E" => 17, "W" => 0, "N" => 3, "S" => 11, "direction" => "S"}
    expected_distance = 25
    # Act
    distance = navigation |> NavigationSystem.calculate_distance()
    # Assert
    assert distance == expected_distance
  end

  test "Parse string instruction into manageable tuple" do
    # Arrange
    str_instruction = "N10"
    expected_tuple = {"N", 10}
    # Act
    tuple_instruction = NavigationSystem.parse_instruction(str_instruction)
    # Assert
    assert tuple_instruction == expected_tuple
  end

  test "Rotate all points in the way point to the right" do
    # Arrange
    current_points = %{"N" => 1, "W" => 8, "movepoint" => %{"N" => 10, "W" => 80}}
    expected_points = %{"E" => 1, "N" => 8, "movepoint" => %{"N" => 10, "W" => 80}}
    # Act
    rotated_points = NavigationSystem.do_instruction(current_points, "R", 90, :waypoint)
    # Assert
    assert rotated_points == expected_points
  end

  test "Rotate all points in the way point to the left" do
    # Arrange
    current_points = %{"N" => 1, "W" => 8, "movepoint" => %{"N" => 10, "W" => 80}}
    expected_points = %{"W" => 1, "S" => 8, "movepoint" => %{"N" => 10, "W" => 80}}
    # Act
    rotated_points = NavigationSystem.do_instruction(current_points, "L", 90, :waypoint)
    # Assert
    assert rotated_points == expected_points
  end

  test "Move forward base on waypoint updates movepoint" do
    # Arrange
    current_points = %{"S" => 10, "E" => 4, "movepoint" => %{"E" => 170, "N" => 38}}
    expected_points = %{"S" => 10, "E" => 4, "movepoint" => %{"E" => 214, "S" => 72}}
    # Act
    updated_points = NavigationSystem.do_instruction(current_points, "F", 11, :waypoint)
    # Asserr
    assert updated_points == expected_points
  end

  test "Navigate waypoint to an opposite cardinal point we currently have" do
    # Arrange
    init_navigation = %{"E" => 10, "N" => 50, movepoint: %{}}
    expected_navigation = %{"W" => 10, "N" => 50, movepoint: %{}}
    # Act
    navigation = NavigationSystem.do_instruction(init_navigation, "W", 20, :waypoint)
    # Assert
    assert navigation == expected_navigation
  end

  test "Navigate waypoint to a same cardinal point we currently have" do
    # Arrange
    init_navigation = %{"E" => 10, "N" => 50, movepoint: %{}}
    expected_navigation = %{"E" => 10, "N" => 70, movepoint: %{}}
    # Act
    navigation = NavigationSystem.do_instruction(init_navigation, "N", 20, :waypoint)
    # Assert
    assert navigation == expected_navigation
  end

  test "Sample peform navigation system with waypoint" do
    # Arrange
    instructions = [{"F", 10}, {"N", 3}, {"F", 7}, {"R", 90}, {"F", 11}]

    initial_navigation = %{
      "E" => 10,
      "N" => 1,
      "movepoint" => %{"E" => 0, "N" => 0}
    }

    expected_navigation = %{
      "E" => 4,
      "S" => 10,
      "movepoint" => %{"E" => 214, "S" => 72}
    }

    # Act
    navigation = NavigationSystem.navigate(initial_navigation, instructions, :waypoint)
    # Assert
    assert navigation == expected_navigation
  end
end

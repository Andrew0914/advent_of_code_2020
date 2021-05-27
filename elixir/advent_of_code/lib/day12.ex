defmodule NavigationSystem do
  defp get_name_origin(key_location) do
    number_location =
      if key_location <= 0,
        do: key_location + 1,
        else: key_location

    %{1.0 => "N", 0.25 => "E", 0.5 => "S", 0.75 => "W"}
    |> Map.get(number_location)
  end

  defp get_number_origin(origin) do
    %{"N" => 1.0, "E" => 0.25, "S" => 0.5, "W" => 0.75}
    |> Map.get(origin)
  end

  def where_it_does_turn(origin, "L", degrees) do
    (get_number_origin(origin) + (1 - degrees / 360) - 1)
    |> get_name_origin()
  end

  def where_it_does_turn(origin, "R", degrees) do
    (get_number_origin(origin) + degrees / 360 - 1)
    |> get_name_origin()
  end

  def do_instruction(current_points, "R", degrees) do
    new_direction = Map.get(current_points, "direction") |> where_it_does_turn("R", degrees)

    current_points
    |> Map.put("direction", new_direction)
  end

  def do_instruction(current_points, "L", degrees) do
    new_direction = Map.get(current_points, "direction") |> where_it_does_turn("L", degrees)

    current_points
    |> Map.put("direction", new_direction)
  end

  def do_instruction(current_points, "F", distance) do
    current_direction = Map.get(current_points, "direction")
    current_distance = Map.get(current_points, current_direction)

    current_points
    |> Map.put(current_direction, current_distance + distance)
  end

  def do_instruction(current_points, cardinal_point, distance) do
    current_points
    |> Map.put(cardinal_point, Map.get(current_points, cardinal_point) + distance)
  end

  # TODO update do_instruction functions to return a tuple with updated information (whatever a map or and array(solution 1 or 2))
  # TODO apply tuples from do_instruction functions into map on solution 1
  # TODO update tests for do_instruction functions
  # TODO create do_instruction functions to waypoint's rotatio L,R
  # TODO create do_instruction function to movepoint's forwarding F

  defp update_index(navigation) do
    navigation |> Map.put("index", Map.get(navigation, "index") + 1)
  end

  def navigate(navigation, instructions) do
    if navigation["index"] >= length(instructions) do
      navigation
    else
      {action, value} = instructions |> Enum.at(navigation["index"])

      do_instruction(navigation, action, value)
      |> update_index()
      |> navigate(instructions)
    end
  end

  def calculate_distance(navigation) do
    abs(navigation["E"] - navigation["W"]) + abs(navigation["N"] - navigation["S"])
  end

  def parse_instruction(instruction) do
    action = instruction |> String.at(0)
    value = instruction |> String.slice(1, String.length(instruction) - 1) |> String.to_integer()
    {action, value}
  end

  def solution_one(file_path) do
    initial_navigation = %{
      "index" => 0,
      "E" => 0,
      "W" => 0,
      "N" => 0,
      "S" => 0,
      "direction" => "E"
    }

    instructions =
      File.read!(file_path)
      |> String.split(~r/\r\n|\n/)
      |> Enum.map(&parse_instruction/1)
    initial_navigation |> navigate(instructions) |> calculate_distance()
  end
end

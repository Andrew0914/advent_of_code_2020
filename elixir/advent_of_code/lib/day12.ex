defmodule NavigationSystem do
  defp get_point_name(key_point) do
    number_point =
      if key_point <= 0,
        do: key_point + 1,
        else: key_point

    %{1.0 => "N", 0.25 => "E", 0.5 => "S", 0.75 => "W"}[number_point]
  end

  defp get_number_point(name_point) do
    %{"N" => 1.0, "E" => 0.25, "S" => 0.5, "W" => 0.75}[name_point]
  end

  def where_does_it_turn(name_point, "L", degrees) do
    (get_number_point(name_point) + (1 - degrees / 360) - 1)
    |> get_point_name()
  end

  def where_does_it_turn(name_point, "R", degrees) do
    (get_number_point(name_point) + degrees / 360 - 1)
    |> get_point_name()
  end

  def do_instruction(current_points, turn, degrees) when turn == "R" or turn == "L" do
    new_direction = Map.get(current_points, "direction") |> where_does_it_turn(turn, degrees)
    %{current_points | "direction" => new_direction}
  end

  def do_instruction(current_points, "F", distance) do
    current_direction = Map.get(current_points, "direction")
    current_distance = Map.get(current_points, current_direction)
    %{current_points | current_direction => current_distance + distance}
  end

  def do_instruction(current_points, cardinal_point, distance) do
    %{current_points | cardinal_point => current_points[cardinal_point] + distance}
  end

  # Specials for solution 2
  def what_key(key) do
    %{"N" => "S", "S" => "N", "E" => "W", "W" => "E"}[key]
  end

  defp eval_movement({point_key, point_value}, movement) do
    if (movement |> Map.new())[point_key] == nil do

      {movement_key, movement_value} =
        movement |> Enum.find(fn {movement_key, _} -> movement_key == what_key(point_key) end)

      {if(point_value > movement_value, do: point_key, else: movement_key),
       abs(point_value - movement_value)}
    else
      {_, movement_value} =
        movement |> Enum.find(fn {movement_key, _} -> movement_key == point_key end)

      {point_key, movement_value + point_value}
    end
  end

  def calculate_movepoint(movepoint, movement) do
    movepoint
    |> Enum.map(&eval_movement(&1, movement))
    |> Map.new()
  end

  def do_instruction(current_points, "F", distance, :waypoint) do
    current_movepoint =
      current_points["movepoint"] |> Enum.map(fn {key, value} -> {key, value} end)

    new_movement =
      current_points
      |> Enum.filter(fn {key, _} -> key != "movepoint" end)
      |> Enum.map(fn {key, value} -> {key, value * distance} end)

    calculated_movepoin =
      current_movepoint
      |> calculate_movepoint(new_movement)

    current_points |> Map.put("movepoint", calculated_movepoin)
  end

  def do_instruction(current_points, turn, degrees, :waypoint) when turn == "R" or turn == "L" do
    current_points
    |> Enum.map(fn {key, value} ->
      if key != "movepoint",
        do: {where_does_it_turn(key, turn, degrees), value},
        else: {key, value}
    end)
    |> Map.new()
  end

  def do_instruction(current_points, cardinal_point, distance, :waypoint) do
    if current_points[cardinal_point] == nil do
      {waypoint_key, waypoint_value} =
        current_points |> Enum.find(fn {key, _} -> key == what_key(cardinal_point) end)

      current_points
      |> Map.delete(waypoint_key)
      |> Map.put(if(distance > waypoint_value, do: cardinal_point, else: waypoint_key), abs(distance - waypoint_value))
    else
      do_instruction(current_points, cardinal_point, distance)
    end
  end

  def navigate(navigation, instructions) do
    if length(instructions) > 0 do
      [{action, value} | remaining_instructions] = instructions

      do_instruction(navigation, action, value)
      |> navigate(remaining_instructions)
    else
      navigation
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

  defp get_istructions(file_path) do
    File.read!(file_path)
    |> String.split(~r/\r\n|\n/)
    |> Enum.map(&parse_instruction/1)
  end

  def solution_one(file_path) do
    %{
      "E" => 0,
      "W" => 0,
      "N" => 0,
      "S" => 0,
      "direction" => "E"
    }
    |> navigate(get_istructions(file_path))
    |> calculate_distance()
  end

  def navigate(navigation, instructions, :waypoint) do
    if length(instructions) > 0 do
      [{action, value} | remaining_instructions] = instructions

      do_instruction(navigation, action, value, :waypoint)
      |> navigate(remaining_instructions, :waypoint)
    else
      navigation
    end
  end

  def solution_two(file_path) do
    %{
      "E" => 10,
      "N" => 1,
      "movepoint" => %{"E" => 0, "N" => 0}
    }
    |> navigate(get_istructions(file_path), :waypoint)
    |> Map.get("movepoint")
    |> Enum.reduce(0, fn {_, value}, acc -> acc + value end)
  end
end

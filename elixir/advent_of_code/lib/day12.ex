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

  def do_instruction(current_points, turn, degrees) when turn == "R" or turn == "L" do
    new_direction = Map.get(current_points, "direction") |> where_it_does_turn(turn, degrees)

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

  # Specials for solution 2

  def do_instruction(current_points, turn, degrees, :waypoint) when turn == "R" or turn == "L" do
    current_points
    |> Enum.map(fn {key, value} ->
      if key != "movepoint" and key != "index",
        do: {where_it_does_turn(key, turn, degrees), value},
        else: {key, value}
    end)
    |> Map.new()
  end

  def calculate_movepoint(movepoint, movement) do
    movepoint
    |> Enum.map(fn {key, value} ->
      cond do
        key == "E" or key == "W" ->
          {mkey, mvalue} = movement |> Enum.find(fn {mkey, _} -> mkey == "E" or mkey == "W" end)

          cond do
            key == mkey ->
              {key, mvalue + value}

            true ->
              {if(value > mvalue, do: key, else: mkey), abs(value - mvalue)}
          end

        key == "N" or key == "S" ->
          {mkey, mvalue} = movement |> Enum.find(fn {mkey, _} -> mkey == "N" or mkey == "S" end)

          cond do
            key == mkey ->
              {key, mvalue + value}

            true ->
              {if(value > mvalue, do: key, else: mkey), abs(value - mvalue)}
          end
      end
    end)
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

  def what_key(key) do
    %{"N" => "S", "S" => "N", "E" => "W", "W" => "E"} |> Map.get(key)
  end

  # test to just have to keys for way point
  def do_instruction(current_points, cardinal_point, distance, :waypoint) do
    if current_points[cardinal_point] == nil do
      {wkey, wvalue} =
        current_points |> Enum.find(fn {key, value} -> key == what_key(cardinal_point) end)

      current_points
      |> Map.delete(wkey)
      |> Map.put(if(distance > wvalue, do: cardinal_point, else: wkey), abs(distance - wvalue))
    else
      do_instruction(current_points, cardinal_point, distance)
    end
  end

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

  def navigate(navigation, instructions, :waypoint) do
    if navigation["index"] >= length(instructions) do
      navigation
    else
      {action, value} = instructions |> Enum.at(navigation["index"])

      do_instruction(navigation, action, value, :waypoint)
      |> update_index()
      |> navigate(instructions, :waypoint)
    end
  end

  def solution_two(file_path) do
    initial_navigation = %{
      "index" => 0,
      "E" => 10,
      "N" => 1,
      "movepoint" => %{"E" => 0, "N" => 0}
    }

    instructions =
      File.read!(file_path)
      |> String.split(~r/\r\n|\n/)
      |> Enum.map(&parse_instruction/1)

    initial_navigation
    |> navigate(instructions, :waypoint)
    |> Map.get("movepoint")
    |> Enum.reduce(0, fn {key, value}, acc -> acc + value end)
  end
end

defmodule GameBootFixing do
  defp get_code_content(file_path) do
    File.read!(file_path)
  end

  defp parse_instruction(instruction) do
    [txt_instruction, value] = String.split(instruction, " ")
    {number, _} = Integer.parse(value)
    [txt_instruction, number]
  end

  defp get_code_instructions(code_content) do
    code_content
    |> String.split(~r/\r\n|\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(&parse_instruction/1)
  end

  defp execute({"acc", number, accumulator, index}) do
    {index + 1, accumulator + number}
  end

  defp execute({"jmp", number, accumulator, index}) do
    {index + number, accumulator}
  end

  defp execute({"nop", _, accumulator, index}) do
    {index + 1, accumulator}
  end

  defp get_accumulator(code_instructions, history, {index, accumulator}) do
    if index >= length(code_instructions) do
      {:terminated, accumulator}
    else
      [txt_instruction, number] = Enum.at(code_instructions, index)

      if Enum.count(history, &(&1 == {txt_instruction, index})) >= 1 do
        {:loop, accumulator}
      else
        get_accumulator(
          code_instructions,
          history ++ [{txt_instruction, index}],
          execute({txt_instruction, number, accumulator, index})
        )
      end
    end
  end

  def get_accumulator_before_infitine_loop(code_file_path) do
    get_code_content(code_file_path)
    |> get_code_instructions()
    |> get_accumulator([], {0, 0})
  end

  # ----- PART 2 -----

  defp fix(bug_instruction) do
    [txt_instruction, number] = bug_instruction

    case txt_instruction do
      "jmp" -> ["nop", number]
      "nop" -> ["jmp", number]
    end
  end

  def get_accumulator_after_fixing_bug(code_file_path) do
    code_instructions =
      get_code_content(code_file_path)
      |> get_code_instructions()

    code_instructions
    |> Enum.with_index()
    |> Enum.filter(fn {instruction, _} ->
      [txt_instruction, _] = instruction
      txt_instruction == "jmp" or txt_instruction == "nop"
    end)
    |> Enum.reduce_while(0, fn bug, acc ->
      {bug_instruction, index} = bug

      acc_status =
        List.replace_at(code_instructions, index, fix(bug_instruction))
        |> get_accumulator([], {0, 0})

      if elem(acc_status, 0) == :loop, do: {:cont, 0}, else: {:halt, acc_status}
    end)
  end
end

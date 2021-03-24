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

  defp execute({"acc", number, count, index}) do
    {index + 1, count + number}
  end

  defp execute({"jmp", number, count, index}) do
    {index + number, count}
  end

  defp execute({"nop", _, count, index}) do
    {index + 1, count}
  end

  defp get_count(code_instructions, history, {index, count}) do
    [txt_instruction, number] = Enum.at(code_instructions, index)

    if Enum.count(history, &(&1 == {txt_instruction, index})) >= 1 do
      count
    else
      get_count(
        code_instructions,
        history ++ [{txt_instruction, index}],
        execute({txt_instruction, number, count, index})
      )
    end
  end

  def get_count_before_infitine_loop(code_file_path) do
    get_code_content(code_file_path)
    |> get_code_instructions()
    |> get_count([], {0, 0})
  end
end

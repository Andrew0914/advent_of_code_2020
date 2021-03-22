defmodule GameBootFixing do
  defp get_code_content(file_path) do
    File.read!(file_path)
  end

  defp get_code_instructions(code_content) do
    code_content
    |> String.split(~r/\r\n|\n/)
    |> Enum.filter(&(&1 != ""))
    |> Enum.map(fn instruction ->
      [txt_instruction, value] = String.split(instruction, " ")
      {number, _} = Integer.parse(value)
      [txt_instruction, number]
    end)
  end

  defp get_count(code_instructions, count, history, index) do
    [txt_instruction, number] = Enum.at(code_instructions, index)

    if Enum.count(history, &(&1 == {txt_instruction, index})) >= 1 do
      count
    else
      case txt_instruction do
        "acc" ->
          get_count(
            code_instructions,
            count + number,
            history ++ [{txt_instruction, index}],
            index + 1
          )

        "jmp" ->
          get_count(
            code_instructions,
            count,
            history ++ [{txt_instruction, index}],
            index + number
          )

        "nop" ->
          get_count(code_instructions, count, history ++ [{txt_instruction, index}], index + 1)
      end
    end
  end

  def get_count_before_infitine_loop(code_file_path) do
    get_code_content(code_file_path)
    |> get_code_instructions()
    |> get_count(0, [], 0)
  end
end

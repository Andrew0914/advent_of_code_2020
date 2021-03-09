defmodule CustomDeclarationForms do
  defp get_forsm_file_content(file_path) do
    File.read!(file_path)
  end

  defp get_forms_answers(content) do
    content
    |> String.split("\n\n")
    |> Enum.map(fn group_answers -> parse_group_answers(group_answers) end)
  end

  defp parse_group_answers(group_answers) do
    group_answers
    |> String.split("\n")
    |> Enum.join("")
    |> String.graphemes()
  end

  def sum_of_yes_answers(file_path) do
    get_forsm_file_content(file_path)
    |> get_forms_answers()
    |> Enum.map(fn answers -> Enum.uniq(answers) end)
    |> Enum.reduce(0, fn diff_answers, acc -> acc + length(diff_answers) end)
  end
end

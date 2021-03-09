defmodule CustomDeclarationForms do
  # --- PART 1 ---
  defp get_forsm_file_content(file_path) do
    File.read!(file_path)
  end

  defp get_forms_answers(content) do
    content
    |> String.split("\n\n")
    |> Enum.map(&parse_group_answers/1)
  end

  defp parse_group_answers(group_answers) do
    individual_answers =
      group_answers
      |> String.split("\n")

    answers =
      individual_answers
      |> Enum.join("")
      |> String.graphemes()

    %{participants: length(individual_answers), answers: answers}
  end

  def sum_of_yes_answers_from_anyone(file_path) do
    get_forsm_file_content(file_path)
    |> get_forms_answers()
    |> Enum.map(fn answers -> Enum.uniq(Map.get(answers, :answers)) end)
    |> Enum.reduce(0, fn diff_answers, acc -> acc + length(diff_answers) end)
  end

  # --- PART 2 ---
  defp get_answers_ocurrences(answers) do
    ocurrences =
      Map.get(answers, :answers)
      |> Enum.sort()
      |> Enum.reduce(%{}, fn answer, acc ->
        Map.update(acc, answer, 1, fn ocurrences -> ocurrences + 1 end)
      end)

    %{participants: Map.get(answers, :participants), ocurrences: ocurrences}
  end

  defp questions_answered_by_everyone(answers_ocurrences) do
    Map.get(answers_ocurrences, :ocurrences)
    |> Map.values()
    |> Enum.count(&(&1 == Map.get(answers_ocurrences, :participants)))
  end

  def sum_of_yes_answers_from_everyone(file_path) do
    get_forsm_file_content(file_path)
    |> get_forms_answers()
    |> Enum.map(&get_answers_ocurrences/1)
    |> Enum.reduce(0, fn answers_ocurrences, acc ->
      acc + questions_answered_by_everyone(answers_ocurrences)
    end)
  end
end

defmodule Bank.Boleto do
  @moduledoc """
  Used for parsing and validation payment boletos
  """

  @enforce_keys [:due_date, :value]
  defstruct [:due_date, :value]

  @base_date ~D[1997-10-07]

  def parse(boleto_str) do
    with {:ok, boleto} <- split(boleto_str),
         {:ok, true} <- module_10_validation(boleto),
         {:ok, true} <- module_11_validation(boleto),
         {:ok, %{"date" => due_date, "value" => value}} <- parse_payment_info(boleto) do
      {:ok,
       %Bank.Boleto{
         due_date: due_date,
         value: value
       }}
    end
  end

  def module_10_validation([first, second, third, _, _]) do
    Enum.all?([first, second, third], fn code -> validate_module_10(code) end)
    |> case do
      true -> {:ok, true}
      _ -> {:error, "erro na validação de módulo 10"}
    end
  end

  def module_11_validation([_, _, _, vd, _] = boleto) do
    case make_barcode_string(boleto) do
      {:ok, barcode} ->
        {sum, _} =
          barcode
          |> String.reverse()
          |> String.graphemes()
          |> Enum.reduce({0, 2}, fn digit, {acc, multiplier} ->
            value_to_sum = String.to_integer(digit) * multiplier
            multiplier = if multiplier === 9, do: 2, else: multiplier + 1

            {acc + value_to_sum, multiplier}
          end)

        remainer = rem(sum, 11)

        validation_digit =
          case 11 - remainer do
            0 -> 1
            10 -> 1
            11 -> 1
            value -> value
          end

        if validation_digit == String.to_integer(vd) do
          {:ok, true}
        else
          {:error, "erro na validação de módulo 11"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def module_11_validation(_), do: {:error, "erro na validação de módulo 11"}

  def parse_payment_info([_, _, _, _, payment_data]) do
    try do
      if String.length(payment_data) == 14 do
        {days_to_add, value_string} = String.split_at(payment_data, 4)

        date = Date.add(@base_date, String.to_integer(days_to_add))
        value = Decimal.new(value_string) |> Decimal.div(100)

        {:ok,
         %{
           "date" => date,
           "value" => value
         }}
      else
        {:error, "informação de pagamento inválida"}
      end
    rescue
      _e in RuntimeError -> {:error, "informação de pagamento inválida"}
    end
  end

  def parse_payment_info(_), do: {:error, "boleto inválido"}

  def make_barcode_string([first_code, second_code, third_code, _, payment_info]) do
    try do
      {first_part, _} = String.split_at(first_code, -1)
      {second_part, _} = String.split_at(second_code, -1)
      {third_part, _} = String.split_at(third_code, -1)

      %{
        "bank_code" => bank_code,
        "barcode" => barcode,
        "currency_code" => currency_code
      } = extract_bank_and_currency(first_part)

      {:ok, bank_code <> currency_code <> payment_info <> barcode <> second_part <> third_part}
    rescue
      e in RuntimeError -> {:error, e}
    end
  end

  def make_barcode_string(_), do: {:error, "dígitos inválidos"}

  def split(code) do
    if String.match?(code, ~r/^\d{5}\.\d{5} \d{5}\.\d{6} \d{5}\.\d{6} \d \d{14}$/) do
      barcode =
        code
        |> String.replace(~r/\.+/, "")
        |> String.split(" ")

      {:ok, barcode}
    else
      {:error, "formato inválido"}
    end
  end

  defp extract_bank_and_currency(code) do
    bank_code = String.slice(code, 0, 3)
    currency_code = String.slice(code, 3, 1)
    barcode = String.slice(code, -5, 6)

    %{
      "bank_code" => bank_code,
      "barcode" => barcode,
      "currency_code" => currency_code
    }
  end

  defp validate_module_10(code_to_validate) do
    {code, validation_digit} = String.split_at(code_to_validate, -1)

    sum =
      code
      |> String.reverse()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {digit, index}, acc ->
        multiplying_factor = 2 - rem(index, 2)

        value_to_sum =
          if (value = String.to_integer(digit) * multiplying_factor) > 9 do
            div(value, 10) + rem(value, 10)
          else
            value
          end

        acc + value_to_sum
      end)

    sub =
      if (value = Float.ceil(sum / 10) * 10 - sum) == 10 do
        0
      else
        value
      end

    sub == String.to_integer(validation_digit)
  end
end

defmodule Bank.BoletoTest do
  use ExUnit.Case

  alias Bank.Boleto

  @valid_boleto [
    "2379338128",
    "60037265885",
    "60000063309",
    "6",
    "83680000083151"
  ]

  @another_valid_boleto [
    "2379338128",
    "60030557163",
    "65000063308",
    "4",
    "83080000058584"
  ]

  @invalid_boleto [
    "2379338148",
    "60037262285",
    "60000063709",
    "4",
    "83620000083151"
  ]

  @invalid_module_10 "23793.38122 60030.557163 65000.063308 4 83080000058584"

  @invalid_module_11 "23793.38128 60030.557163 65000.063308 5 83080000058584"

  @valid_code "23793.38128 60030.557163 65000.063308 4 83080000058584"

  describe "parse_boleto/1" do
    test "returns {:error, reason} when invalid module 10" do
      assert {:error, "erro na validação de módulo 10"} = Boleto.parse(@invalid_module_10)
    end

    test "returns {:error, reason} when invalid module 11" do
      assert {:error, "erro na validação de módulo 11"} = Boleto.parse(@invalid_module_11)
    end

    test "returns {:ok, %Boleto{}} when valid data is passed" do
      value = Decimal.new("585.84")

      assert {
        :ok,
        %Boleto{
          due_date: ~D[2020-07-06],
          value: ^value
        }
      } = Boleto.parse(@valid_code)
    end
  end

  describe "module_10_validation/1" do
    test "returns {:ok, true} for valid boletos" do
      assert {:ok, true} = Boleto.module_10_validation(@valid_boleto)
    end

    test "returns {:error, reason} for invalid boletos" do
      assert {:error, "erro na validação de módulo 10"} =
               Boleto.module_10_validation(@invalid_boleto)
    end
  end

  describe "module_11_validation/1" do
    test "returns {:ok, true} for valid code" do
      assert {:ok, true} = Boleto.module_11_validation(@valid_boleto)
      assert {:ok, true} = Boleto.module_11_validation(@another_valid_boleto)
    end

    test "returns {:error, reason} for invalid code" do
      assert {:error, "erro na validação de módulo 11"} =
               Boleto.module_11_validation(@invalid_boleto)

      assert {:error, "erro na validação de módulo 11"} = Boleto.module_11_validation([])
    end
  end

  describe "parse_payment_info" do
    test "returns {:ok, %{}} for valid data" do
      first_value = Decimal.new("831.51")

      assert {:ok,
              %{
                "date" => ~D[2020-09-04],
                "value" => ^first_value
              }} = Boleto.parse_payment_info(@valid_boleto)

      second_value = Decimal.new("585.84")

      assert {:ok,
              %{
                "date" => ~D[2020-07-06],
                "value" => ^second_value
              }} = Boleto.parse_payment_info(@another_valid_boleto)
    end

    test "returns {:error, errors} for invalid data" do
      assert {:error, "informação de pagamento inválida"} =
               Boleto.parse_payment_info([
                 "",
                 "",
                 "",
                 "",
                 ""
               ])

      assert {:error, "boleto inválido"} = Boleto.parse_payment_info([])
    end
  end

  describe "marke_barcode_string/1" do
    test "make barcode string for valid boletos" do
      assert {:ok, "2379836800000831513381260037265886000006330"} =
               Boleto.make_barcode_string(@valid_boleto)
    end

    test "gives error on invalid input" do
      assert {:error, _} = Boleto.make_barcode_string([])
    end
  end

  describe "boleto_split/1" do
    test "returns error when invalid format" do
      assert {:error, "formato inválido"} = Boleto.split("1924891284")
    end

    test "splits correctly when valid format" do
      assert {:ok, @another_valid_boleto} =
               Boleto.split("23793.38128 60030.557163 65000.063308 4 83080000058584")
    end
  end
end

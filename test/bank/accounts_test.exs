defmodule Bank.AccountsTest do
  use Bank.DataCase

  alias Bank.Accounts
  import Bank.AccountsFixtures
  alias Bank.Accounts.{User, UserToken}

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/1" do
    test "does not return the user if the email does not exist" do
      refute Accounts.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture()
      refute Accounts.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = user_fixture()

      assert %User{id: ^id} =
               Accounts.get_user_by_email_and_password(user.email, valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email, document and password to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               password: ["não pode estar em branco"],
               email: ["não pode estar em branco"],
               document: ["não pode estar em branco"]
             } = errors_on(changeset)
    end

    test "validates email, document and password when given" do
      {:error, changeset} =
        Accounts.register_user(%{email: "not valid", document: "not valid", password: "not valid"})

      assert %{
               email: ["formato inválido"],
               document: ["documento inválido"],
               password: [
                 "deve possuir ao menos um número ou caracter especial",
                 "deve possuir ao menos um caracter maiúsculo",
                 "deve possuir ao menos 12 caracteres"
               ]
             } = errors_on(changeset)
    end

    test "validates repetition documents" do
      {:error, changeset} = Accounts.register_user(%{document: "99999999999"})

      assert "documento inválido" in errors_on(changeset).document
    end

    test "validates invalid documents" do
      {:error, changeset} = Accounts.register_user(%{document: "91929994998"})

      assert "documento inválido" in errors_on(changeset).document
    end

    test "validates maximum values for e-mail and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_user(%{email: too_long, password: too_long})
      assert "deve possuir no máximo 160 caracteres" in errors_on(changeset).email
      assert "deve possuir no máximo 80 caracteres" in errors_on(changeset).password
    end

    test "validates e-mail uniqueness" do
      %{email: email} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{email: email})
      assert "já existe uma conta com este e-mail" in errors_on(changeset).email

      # Now try with the upper cased e-mail too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_user(%{email: String.upcase(email)})
      assert "já existe uma conta com este e-mail" in errors_on(changeset).email
    end

    test "validates document uniqueness" do
      %{document: document} = user_fixture()

      {:error, changeset} = Accounts.register_user(%{document: document})
      assert "já existe uma conta com este documento" in errors_on(changeset).document
    end

    test "registers users with a hashed password" do
      email = unique_user_email()

      {:ok, user} =
        Accounts.register_user(%{
          name: "Roberto Baptista",
          email: email,
          document: valid_user_document(),
          password: valid_user_password(),
          confirm_password: valid_user_password()
        })

      assert user.email == email
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end

  describe "user balance starts at zero" do
    test "when created without a balance" do
      %{balance: balance} = user_fixture()

      assert Decimal.eq?(balance, 0)
    end

    test "when a value is passed to register_user" do
      {:ok, user} =
        Accounts.register_user(%{
          name: "Roberto Baptista",
          email: unique_user_email(),
          document: valid_user_document(),
          password: valid_user_password(),
          confirm_password: valid_user_password(),
          balance: 500.0
        })

        assert Decimal.eq?(user.balance, 0)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:name, :password, :email, :document]
    end
  end

  describe "change_user_email/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_email(%User{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_user_email/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} = Accounts.apply_user_email(user, valid_user_password(), %{})
      assert %{email: ["não foi alterado"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, valid_user_password(), %{email: "not valid"})

      assert %{email: ["formato inválido"]} = errors_on(changeset)
    end

    test "validates maximum value for e-mail for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_user_email(user, valid_user_password(), %{email: too_long})

      assert "deve possuir no máximo 160 caracteres" in errors_on(changeset).email
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_email(user, "invalid", %{email: unique_user_email()})

      assert %{current_password: ["senha inválida"]} = errors_on(changeset)
    end

    test "applies the e-mail without persisting it", %{user: user} do
      email = unique_user_email()
      {:ok, user} = Accounts.apply_user_email(user, valid_user_password(), %{email: email})
      assert user.email == email
      assert Accounts.get_user!(user.id).email != email
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:password]
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: [
                 "deve possuir ao menos um número ou caracter especial",
                 "deve possuir ao menos um caracter maiúsculo",
                 "deve possuir ao menos 12 caracteres"
               ],
               password_confirmation: ["senhas não conferem"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{password: too_long})

      assert "deve possuir no máximo 80 caracteres" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, "invalid", %{password: valid_user_password()})

      assert %{current_password: ["senha inválida"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "n3whug3P45sw0rd!"
        })

      assert is_nil(user.password)
      assert Accounts.get_user_by_email_and_password(user.email, "n3whug3P45sw0rd!")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_user_session_token(user)

      {:ok, _} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "n3whug3P45sw0rd"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id:
            user_fixture(%{
              document: another_valid_document()
            }).id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_user_session_token(user)
      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end
end

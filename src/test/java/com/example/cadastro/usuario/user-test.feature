Feature: Testes da API de Usuários

  Background:
    # Define a URL base da sua API
    * url 'http://localhost:8080/usuario'

  Scenario: Criar um novo usuário com sucesso
    # O payload que será enviado no POST
    Given request { name: 'Hamilton QA', email: 'hamilton@test.com' }
    When method post
    Then status 200
    # Como seu controller retorna ResponseEntity.ok().build(), o body é vazio
    # Mas podemos validar o banco no próximo passo (GET)

  Scenario: Consultar usuário por e-mail
    # Primeiro garantimos que o usuário existe (criando um)
    * def userEmail = 'busca@test.com'
    * karate.call('user-test.feature@CreateUser', { name: 'Busca Teste', email: userEmail })

    Given param email = userEmail
    When method get
    Then status 200
    And match response.name == 'Busca Teste'
    And match response.email == userEmail
    And match response.id == '#number'

  Scenario: Tentar buscar usuário com e-mail inexistente (Erro 500 conforme seu Service)
    # Seu service lança RuntimeException("E-mail not found"), o que gera status 500 no Spring padrão
    Given param email = 'naoexiste@test.com'
    When method get
    Then status 500
    # Se o Spring retornar o erro padrão no body, podemos validar a mensagem
    # And match response.message == 'E-mail not found'

  Scenario: Atualizar nome de um usuário existente
    # 1. Cria usuário
    Given request { name: 'Original', email: 'update@test.com' }
    When method post
    Then status 200

    # 2. Busca o ID dele (simulando a necessidade do ID para o PUT)
    Given param email = 'update@test.com'
    When method get
    * def userId = response.id

    # 3. Atualiza usando o ID via @RequestParam
    Given path '/usuario'
    And param email = 'update@test.com'
    And request { name: 'Nome Atualizado' }
    When method put
    Then status 200

  # Tag auxiliar para reaproveitar código se necessário
  @CreateUser
  Scenario:
    Given request { name: '#(name)', email: '#(email)' }
    When method post
    Then status 200
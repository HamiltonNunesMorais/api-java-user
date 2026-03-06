package com.example.cadastro.usuario;

import com.intuit.karate.junit5.Karate;

class UserRunner {

    @Karate.Test
    Karate testUsers() {
        // O Karate vai procurar o arquivo .feature nesta mesma pasta
        return Karate.run("classpath:com/example/cadastro/usuario/user-test.feature");
    }

}
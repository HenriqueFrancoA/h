# H

Um aplicativo mobile, inspirado no famoso X. Unindo a linguagem Flutter com Firebase este aplicativo possui funções como: 

- Criação da sua conta pela função "AUTHENTICATION" do Firebase, garantindo a proteção do usuário.
- Criar suas próprias publicações, com ou sem uma imagem anexada.
- Interagir nas publicações de outras pessoas, com comentários, curtidas e/ou compartilhamentos.
- Criar seu perfil personalizado.

 OBS: Você precisará configurar o seu próprio firebase caso queria rodar o código.

## Índice

- [Instalação](#instalação)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Uso](#uso)
- [Contribuição](#contribuição)

## Instalação

Para rodar o aplicativo em sua máquina, você precisará ter o [FLUTTER](https://docs.flutter.dev/get-started/install?gclid=Cj0KCQiAr8eqBhD3ARIsAIe-buOCyorPJPqdTYdVsdQKOzuPqGzAprGPu3pwPxjTnLtOOHdLSoAsh1saAgUvEALw_wcB&gclsrc=aw.ds), o [ANDROID STUDIO](https://developer.android.com/studio?gclid=Cj0KCQiAr8eqBhD3ARIsAIe-buMqmR_CMoH5O7WV2e1b4c3vFVYSijnSrKssVmVXcEa6bNvX_FOnd-AaAl25EALw_wcB&gclsrc=aw.ds&hl=pt-br) e algum editor como por exemplo [VISUAL STUDIO CODE](https://code.visualstudio.com/download) instalado.
Na sua pasta de escolha use o comando para clonar o repositório e baixar as dependências do projeto:
```
git clone https://github.com/HenriqueFrancoA/h.git
cd h
flutter pub get
flutter run
```

## Estrutura de Pastas
O projeto está organizado com as seguintes pastas:

- apis: Aqui é onde usamos os metodos CRUD para o FIREBASE.
- components: Onde ficam os componentes que são reutilizádos.
- controllers: Controllers tomam conta das lógicas que são aplicadas carregando as listas e fazendo o app se comunicar entre uma tela e outra.
- models: Definições de dados e modelos.
- screens: Telas principais do aplicativo.
- themes: Configurações de tema e estilo.
- utils: Onde ficam as funções que são reutilizádas.

## Uso
![Telas](/assets/gifs/readme01.gif)   ![Demonstração](/assets/gifs/readme02.gif)


## Contribuição
Caso tenha alguma sugestão ou dúvida, me mande um e-mail. 
henriquefrancoaraujo@gmail.com

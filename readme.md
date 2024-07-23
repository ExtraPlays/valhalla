# Valhalla

## Sobre

Este projeto implementa um sistema de jogo multiplayer baseado em equipes com mapas específicos, como "praça" e "bebidas". Os jogadores podem criar salas, juntar-se a elas, competir em rodadas e ter suas pontuações e abates registrados.

## Recursos

- Criação e gerenciamento de salas de jogo.
- Suporte para múltiplos mapas com configurações específicas.
- Sistema de equipes com pontos de spawn definidos.
- Contagem de pontuações e abates.
- Eventos de jogo como início e fim de jogo, jogador morto e atualização de pontuação.

## Configuração

Para configurar este recurso no seu servidor FiveM, siga os passos abaixo:

1. Clone este repositório para a pasta `resources` do seu servidor FiveM.
2. Adicione `ensure valhalla` ao seu arquivo `server.cfg`.
3. Configure os mapas e outras opções no arquivo `config.lua` conforme necessário.

## Uso

Os jogadores podem interagir com o sistema através de comandos ou menus para criar salas, juntar-se a salas existentes, e participar das partidas.

### Comandos

- `/criarSala [nomeDoMapa]` - Cria uma nova sala com o mapa especificado.
- `/entrarSala [IDdaSala]` - Entra em uma sala existente pelo ID.

## Desenvolvimento

Este projeto foi desenvolvido utilizando Lua para o ambiente FiveM. Para contribuir ou modificar, sinta-se à vontade para clonar o repositório e abrir pull requests com suas mudanças.

## Licença

Este projeto é distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

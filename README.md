# Novo Projeto de Jogo (Godot 2D Platformer)

Um jogo de plataforma 2D desenvolvido em Godot Engine com mecânicas de tiro, inimigos e sistema de vida.

## 🎮 Funcionalidades

- **Movimentação do Player**: Andar, pular com Coyote Time e Jump Buffer
- **Sistema de Tiro**: Atira na direção que o personagem está olhando
- **Inimigos**: Patrulham e perseguem o jogador quando dentro do alcance de visão
- **Sistema de Vida**: HUD com barra de vida e contador de HP
- **Colisões**: Sistema de hitbox para balas e inimigos

## 📁 Estrutura do Projeto

```
/workspace/
├── PRINCIPAL.tscn          # Cena principal do jogo
├── Cena1.gd                # Script da cena principal (spawns, HUD)
├── mainchar.gd             # Script do personagem principal
├── ENEMY1.gd               # Script dos inimigos
├── bullet.gd               # Script das balas/projéteis
├── character_body_2d.gd    # Template de referência (não usado)
└── project.godot           # Configuração do projeto Godot
```

## 🎯 Controles

| Ação | Tecla/Botão |
|------|-------------|
| Mover Esquerda/Direita | Setas ou A/D |
| Pular | Espaço (ui_accept) |
| Atirar | Z |
| Selecionar | Botão esquerdo do mouse / Botão do controle |

## ⚙️ Configurações Técnicas

- **Engine**: Godot 4.6+
- **Resolução**: 1920x1080
- **Física**: Jolt Physics (3D)
- **Renderer**: GL Compatibility
- **Plataforma**: Windows (Direct3D 12)

## 🔧 Mecânicas Implementadas

### Personagem Principal (`mainchar.gd`)
- Velocidade: 300 pixels/segundo
- Gravidade personalizada (1200 base, 1.8x ao cair)
- Coyote Time: 0.12s
- Jump Buffer: 0.15s
- Vida: 100 HP
- Cooldown de tiro: 0.2s

### Inimigos (`ENEMY1.gd`)
- Vida: 30 HP
- Velocidade de patrulha: 100 pixels/segundo
- Velocidade de perseguição: 150 pixels/segundo
- Alcance de visão: 250 pixels
- Dano ao jogador: 1 HP (a cada 0.8s)

### Balas (`bullet.gd`)
- Velocidade: 800 pixels/segundo
- Dano: 10 HP

## 🚀 Como Usar

1. Abra o projeto no Godot Engine 4.6+
2. Execute a cena `PRINCIPAL.tscn`
3. Use os controles para mover, pular e atirar
4. Derrote os inimigos evitando seus ataques

## 📝 Notas

- O arquivo `character_body_2d.gd` é apenas um template de referência
- O projeto usa grupos para gerenciar colisões (`player`, `bullet`, `hitbox_inimigo`)
- Sistema de Game Over: recarrega a cena quando HP chega a 0

## 📄 Licença

Projeto desenvolvido para fins educacionais/experimentais.

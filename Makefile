.PHONY: install-claude-skill

## Instala a skill do Claude Code no projeto consumidor.
## Uso: make install-claude-skill TARGET=../meu_projeto
install-claude-skill:
ifndef TARGET
	$(error TARGET não definido. Uso: make install-claude-skill TARGET=../meu_projeto)
endif
	mkdir -p $(TARGET)/.claude/commands
	cp .claude/commands/odin-design-system.md $(TARGET)/.claude/commands/odin-design-system.md
	@echo "Skill instalada em $(TARGET)/.claude/commands/odin-design-system.md"

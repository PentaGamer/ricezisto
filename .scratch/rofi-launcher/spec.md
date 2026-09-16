# Especificação: Launcher Dedicado Rofi & Powermenu (Catppuccin Mocha Mauve)

Status: `ready-for-agent`
Parent: `.scratch/rice-suite/issues/03-rofi-wayland-launcher.md`

## Problem Statement
O lançador padrão do GNOME (Overview) ocupa a tela inteira, interrompendo a visualização das janelas abertas e não possui integração cromática com o tema Catppuccin Mocha Mauve. Além disso, ações de energia (suspender, reiniciar, desligar e bloquear) exigem navegar até o menu superior direito da tela.

## Solution
Criar um módulo GNU Stow `stow/rofi/.config/rofi` com tema exclusivo Catppuccin Mocha Mauve para busca rápida de aplicativos (`drun`), alternador de janelas (`window`) e um script interativo de powermenu acionável por atalhos de teclado.

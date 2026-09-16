# Especificação: Mapeamento de Atalhos Ergonômicos no GNOME (GNOME Keybindings)

Status: `ready-for-agent`
Parent: `.scratch/rice-suite/issues/01-gnome-keybindings.md`

## Problem Statement
Os atalhos nativos do GNOME no Zorin OS 18 não oferecem o fluxo de trabalho ágil e centrado em teclado característico de um Rice de produtividade. Combinações ergonômicas como `Super + Return` para terminal e `Super + Q` para fechar janelas estão ausentes, enquanto `Super + Space` conflita com o alternador de layout de teclado.

## Solution
Criar um mapeamento de atalhos ergonômicos no GNOME 46 Wayland para terminal, controle de janelas, gerenciador de arquivos e lançador de aplicações, com rotina idempotente em script e diagnóstico automatizado.

#!/usr/bin/env python3
# ==============================================================================
# Ricezisto - Rofi Transparent Backdrop & Click-to-Close Wrapper
# ==============================================================================
# Cria uma sobreposição 100% transparente (invisível) cobrindo a tela.
# Permite ver o desktop, papel de parede e janelas normalmente (sem tela preta),
# mas captura cliques fora do Rofi/Powermenu para fechá-los imediatamente.
# Suporta também toggle automático no atalho de teclado e tecla Escape.
# ==============================================================================

import os
import signal
import subprocess
import sys

# 1. Comportamento de Toggle: se o rofi já estiver rodando, encerra e sai
res = subprocess.run(['pkill', '-x', 'rofi'], stderr=subprocess.DEVNULL)
if res.returncode == 0:
    sys.exit(0)

# Importações GTK / Cairo
import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Gdk', '3.0')
from gi.repository import Gtk, Gdk, GLib
import cairo

target_cmd = sys.argv[1:] if len(sys.argv) > 1 else ['rofi', '-show', 'drun']


class RofiBackdropManager:
    def __init__(self, cmd):
        self.cmd = cmd
        self.proc = None
        self.windows = []
        self.is_quitting = False

        display = Gdk.Display.get_default()
        n_monitors = display.get_n_monitors() if display else 1

        # Provedor CSS para transparência completa sem fundo opaco do tema
        screen = Gdk.Screen.get_default()
        css_provider = Gtk.CssProvider()
        css_provider.load_from_data(b'''
        window.transparent-backdrop {
            background-color: transparent;
            background: transparent;
            box-shadow: none;
            border: none;
        }
        ''')
        Gtk.StyleContext.add_provider_for_screen(
            screen, css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        for i in range(n_monitors):
            monitor = display.get_monitor(i)
            geom = monitor.get_geometry()

            win = Gtk.Window(type=Gtk.WindowType.TOPLEVEL)
            win.set_title('rofi-backdrop')
            win.set_role('rofi-backdrop')
            win.set_decorated(False)
            win.set_skip_taskbar_hint(True)
            win.set_skip_pager_hint(True)
            win.set_app_paintable(True)
            win.set_position(Gtk.WindowPosition.CENTER)

            visual = screen.get_rgba_visual()
            if visual:
                win.set_visual(visual)

            win.get_style_context().add_class('transparent-backdrop')

            # Definir dimensões sem ativar o modo fullscreen (o fullscreen no Mutter força fundo preto)
            win.set_default_size(geom.width, geom.height)
            win.resize(geom.width, geom.height)

            win.connect('draw', self.on_draw)
            win.connect('button-press-event', self.on_dismiss)
            win.connect('scroll-event', self.on_dismiss)
            win.connect('key-press-event', self.on_key_press)
            win.add_events(
                Gdk.EventMask.BUTTON_PRESS_MASK
                | Gdk.EventMask.SCROLL_MASK
                | Gdk.EventMask.KEY_PRESS_MASK
            )
            self.windows.append(win)
            win.show_all()

        # Executa o comando filho em seu próprio grupo de processos
        env = os.environ.copy()
        env['ROFI_WRAPPED'] = '1'
        self.proc = subprocess.Popen(self.cmd, env=env, preexec_fn=os.setsid)

        # Monitoramento periódico do processo filho
        GLib.timeout_add(30, self.check_proc_alive)

    def on_draw(self, widget, cr):
        # 100% transparente (limpa a superfície sem pintar cor sólida)
        cr.set_operator(cairo.OPERATOR_CLEAR)
        cr.paint()
        return False

    def check_proc_alive(self):
        if self.proc and self.proc.poll() is not None:
            self.quit()
            return False
        return True

    def on_dismiss(self, widget, event=None):
        self.kill_target()
        self.quit()
        return True

    def on_key_press(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.kill_target()
            self.quit()
            return True
        return False

    def kill_target(self):
        if self.proc and self.proc.poll() is None:
            try:
                os.killpg(os.getpgid(self.proc.pid), signal.SIGTERM)
            except ProcessLookupError:
                pass
        subprocess.run(['pkill', '-x', 'rofi'], stderr=subprocess.DEVNULL)

    def quit(self):
        if self.is_quitting:
            return
        self.is_quitting = True
        for win in self.windows:
            win.destroy()
        Gtk.main_quit()


def main():
    mgr = RofiBackdropManager(target_cmd)
    Gtk.main()


if __name__ == '__main__':
    main()

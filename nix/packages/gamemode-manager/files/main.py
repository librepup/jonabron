import gi
import subprocess
import re
import os

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, GLib

class GameModeManager(Gtk.Window):
    def __init__(self):
        super().__init__()

        icon_path = os.path.join(os.path.dirname(__file__), "/run/current-system/sw/share/pixmaps/gamemode-manager.png")
        if os.path.exists(icon_path):
            self.set_icon_from_file(icon_path)

        header = Gtk.HeaderBar()
        header.set_show_close_button(True)
        header.set_title("Gamemode Manager")
        self.set_titlebar(header)

        btn_refresh = Gtk.Button()
        icon = Gtk.Image.new_from_icon_name("view-refresh-symbolic", Gtk.IconSize.BUTTON)
        btn_refresh.add(icon)
        btn_refresh.connect("clicked", lambda x: self.refresh_list())
        header.pack_start(btn_refresh)

        self.set_border_width(10)
        self.set_default_size(600, 400)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        self.add(vbox)

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_vexpand(True)
        vbox.pack_start(scrolled_window, True, True, 0)

        self.liststore = Gtk.ListStore(str, str, str)
        self.treeview = Gtk.TreeView(model=self.liststore)

        column_names = ["Process Name", "PID", "Registered"]
        for i, column_title in enumerate(column_names):
            renderer = Gtk.CellRendererText()
            if column_title == "Registered":
                renderer.set_property("xalign", 0.5)
            column = Gtk.TreeViewColumn(column_title, renderer, text=i)
            if column_title == "Registered":
                column.set_alignment(0.5)
            self.treeview.append_column(column)

        scrolled_window.add(self.treeview)

        hbox = Gtk.Box(spacing=10)
        vbox.pack_start(hbox, False, False, 0)

        btn_toggle = Gtk.Button(label="Toggle Gamemode")
        btn_toggle.get_style_context().add_class("suggested-action")
        btn_toggle.connect("clicked", self.on_toggle_clicked)
        hbox.pack_start(btn_toggle, True, True, 0)

        btn_quit = Gtk.Button(label="Quit")
        btn_quit.connect("clicked", Gtk.main_quit)
        hbox.pack_start(btn_quit, True, True, 0)

        self.refresh_list()
        self.show_all()

    def check_registration(self, pid):
        """Checks if a specific PID is actually registered in gamemode."""
        try:
            res = subprocess.check_output(["gamemoded", f"--status={pid}"], stderr=subprocess.STDOUT).decode()
            if "registered" in res.lower() and "not registered" not in res.lower():
                return "Yes"
            return "No"
        except:
            return "Unknown"

    def refresh_list(self):
        """Fetches potential PIDs and verifies their registration status."""
        self.liststore.clear()
        try:
            cmd = "gamemodelist | awk '{print $1\" \"$6}' | tail -n +2"
            output = subprocess.check_output(cmd, shell=True).decode().strip()

            if output:
                for line in output.split('\n'):
                    parts = line.split(' ', 1)
                    if len(parts) == 2:
                        pid, name = parts[0], parts[1]
                        is_active = self.check_registration(pid)
                        self.liststore.append([name, pid, is_active])
            else:
                self.liststore.append(["No processes found", "---", "No"])
        except Exception as e:
            print(f"Error refreshing list: {e}")

    def on_toggle_clicked(self, widget):
        selection = self.treeview.get_selection()
        model, treeiter = selection.get_selected()

        if treeiter is None or model[treeiter][1] == "---":
            return

        name, pid = model[treeiter][0], model[treeiter][1]

        dialog = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text="Confirm Action"
        )
        dialog.format_secondary_text(f"Toggle Gamemode for {name} (PID: {pid})?")

        no_button = dialog.get_widget_for_response(Gtk.ResponseType.NO)
        no_button.set_can_default(True)
        no_button.grab_default()

        response = dialog.run()
        dialog.destroy()
        self.refresh_list()

        if response == Gtk.ResponseType.YES:
            subprocess.run(["gamemoded", f"--request={pid}"])
            GLib.timeout_add(800, self.refresh_list)

if __name__ == "__main__":
    win = GameModeManager()
    win.connect("destroy", Gtk.main_quit)
    Gtk.main()

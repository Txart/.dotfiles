# Copyright (c) 2010 Aldo Cornamesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess

from libqtile import bar, layout, widget, extension, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from datetime import datetime

# Color definitions for the bar widget backgrounds
background_colors = ["d17eff", "76acff"]

mod = "mod4"
# terminal = guess_terminal() # default terminal selection
# single-instance makes the first terminal call as a sort of daemon; the rest are "childs" on top of that
# terminal_single_instance = "kitty --single-instance"
# terminal = "kitty"
terminal_alacritty = "/home/txart/software/alacritty/target/release/alacritty"
terminal = "/home/txart/software/ghostty/zig-out/bin/ghostty"
# terminal = "st # overwrite default terminal selection to choose st
email_client = "neomutt"


def take_screenshot_imagemagick(qtile):
    "Uses the import command from ImageMagick library"
    screenshot_filename = (
        "/home/txart/Pictures/Screenshots/"
        + datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
        + ".png"
    )
    # Run the import command
    subprocess.run(["import", screenshot_filename])

    return None


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "k", lazy.layout.grow(), desc="Grow window"),
    Key([mod, "control"], "j", lazy.layout.shrink(), desc="Shrink window"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle floating windows:
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "m", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "control"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # change default prompt to dmenu
    # Key([mod], "p", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        [mod],
        "space",
        lazy.run_extension(
            extension.DmenuRun(dmenu_prompt=">", dmenu_font="Andika-11")
        ),
    ),
    # Self-made. Take screenshots using ImageMagick's import
    Key(
        [mod],
        "Print",
        # lazy.function(take_screenshot_imagemagick),
        # desc="Take screenshots using ImageMagick's import command",
        lazy.spawn("flameshot gui"),
        desc="Take screenshot using flameshot",
    ),
    # Run passmenu
    Key([mod], "p", lazy.spawn("passmenu"), desc="Launch pass in dmenu"),
    # Run rofi for fuzzy file selection!
    Key(
        [mod],
        "o",
        lazy.spawn(
            'bash -c \'FILE=$(fd . $HOME --type f | rofi -dmenu -p "Open file: "); [ -n "$FILE" ] && xdg-open "$FILE"\''
        ),
        desc="Open file with rofi",
    ),
    # Recent files with rofi
    Key(
        [mod, "shift"],
        "o",
        lazy.spawn(
            'bash -c \'FILE=$(find $HOME -type f -mtime -7 | head -50 | rofi -dmenu -p "Recent: "); [ -n "$FILE" ] && xdg-open "$FILE"\''
        ),
        desc="Open recent file with rofi",
    ),
]

groups = [Group(i) for i in "123456789e"]
groupnames = [
    "1-www",
    "2-code",
    "3-term",
    "4",
    "5",
    "6",
    "7",
    "8-file",
    "9-Obs",
    "e-mail",
]

# Autoinitialize
# groups[7] = Group("8", spawn=terminal + "thunar")
groups[7] = Group(
    "8", spawn=[terminal, "-e", "/home/txart/software/yazi/target/release/yazi"]
)
# Add obsidian to auto init in last group
groups[8] = Group("9", spawn=["obsidian"])

for i, g in enumerate(groups):
    g.label = groupnames[i]  # set group name
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                g.name,
                lazy.group[g.name].toscreen(),
                desc="Switch to group {}".format(g.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                g.name,
                lazy.window.togroup(g.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(g.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )


# Scratchpad/Dropdown action
groups.append(
    ScratchPad(
        name="scratchpad",
        dropdowns=[
            # open working_memory.md note in nvim
            DropDown(
                "working_memory",
                cmd=terminal
                + " -e nvim /home/txart/Dropbox/SecondBrain/working_memory.md + ",
            ),
            # launch self_boss.py
            DropDown(
                "rodomopo",
                cmd="kitty --hold rodomopo",
                on_focus_lost_hide=True,
                y=0.6,
            ),
            # A terminal
            DropDown(
                "terminal",
                cmd=terminal,
                opacity=1.0,
                width=0.5,
                height=0.5,
                x=0.25,
                y=0.25,
            ),
        ],
    )
)
# Add keybindings to the dropdown
keys.extend(
    [
        Key([mod], "0", lazy.group["scratchpad"].dropdown_toggle("working_memory")),
        Key([mod], "w", lazy.group["scratchpad"].dropdown_toggle("rodomopo")),
        Key([mod], "t", lazy.group["scratchpad"].dropdown_toggle("terminal")),
    ]
)

layouts = [
    layout.MonadTall(
        ratio=0.56,
        border_focus=background_colors[0],
        # places new window on top of the stack, as the new active window
        new_client_position="top",
        border_width=4,
        margin=4,
    ),
    layout.Max(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                # widget.CurrentLayout(),
                widget.GroupBox(highlight_method="block"),
                widget.Spacer(),  # Everything after this widget is right-aligned
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Backlight(
                    background=background_colors[0],
                    backlight_name="intel_backlight",
                    change_command=None,
                    step=1,
                ),
                widget.Volume(
                    fmt="Vol:{}",
                    background=background_colors[1],
                    step=1,
                    update_interval=0.05,
                ),
                # widget.PulseVolume(
                #     fmt="Vol:{}",
                #     background=background_colors[1],
                #     scroll_step=1,
                #     update_interval=0.05,
                # ),
                # widget.Wlan(background=background_colors[1]),
                widget.Systray(background=background_colors[0]),
                widget.KeyboardLayout(
                    background=background_colors[0],
                    configured_keyboards=["us intl", "es"],
                    update_interval=1,
                ),
                widget.Battery(
                    background=background_colors[1],
                    format="{char}{percent:2.0%}",
                    low_percentage=0.2,
                    notify_below=20,
                    notification_timeout=0,
                ),
                widget.Clock(background=background_colors[0]),
                widget.Memory(
                    background=background_colors[1],
                    measure_mem="G",
                    format="{MemUsed: .1f}{mm}/{MemTotal: .1f}{mm}",
                    update_interval=5,
                ),
                widget.ThermalSensor(
                    background=background_colors[0],
                    update_interval=5,
                ),
                widget.QuickExit(),
            ],
            20,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper="/home/txart/.config/qtile/resources/jwst-carina-nebula.jpg",
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


# Execute the contents of the autostart.sh file once the first time qtile starts
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.Popen([home])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

# Copyright (c) 2010 Aldo Cortesi
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

from typing import List  # noqa: F401
import os
import sys
import subprocess

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import layout, hook, bar, widget
from libqtile.ipc import find_sockfile, Client 
from libqtile.command_client import InteractiveCommandClient 
from libqtile.command_interface import IPCCommandInterface                                                                    

client = InteractiveCommandClient(IPCCommandInterface(Client(find_sockfile())))

from helper import run
from controls import next_keyboard
from apperance import widget_defaults, extension_defaults
from apperance import top_bar, bottom_bar
from debug_logging import logger

# This has to be run this before screens are defined, so that it correctly picks up the order and resulotion
# run("xrandr --output DVI-D-1 --mode 1600x1200 --left-of HDMI-2 --output HDMI-2 --mode 2560x1080 --output HDMI-1 --mode 1920x1080 --right-of HDMI-2")

mod = "mod4"
username = "gergeh"

def bring_group_to_front(group_name):
    try:
        def callback(qtile):
            group = qtile.groups_map[group_name]
            screen = group.info()['screen']
            if screen is None:
                group.cmd_toscreen(screen_map[group_name])
            qtile.cmd_to_screen(screen_map[group_name])
            # qtile.to_screen(screen)
            # qtile.screen[screen].window.focus()
    except Exception as e:
        logger.error(str(e))
        logger.error(sys.exc_info())
        raise
    return lazy.function(callback)

def bring_group_to_screen(group_index):
    try:
        def callback(qtile):
            # logger.error(qtile.__dict__)
            # logger.error(qtile.core.__dict__)
            # logger.error(qtile.groups[group_index].__dict__)
            # logger.error(dir(qtile.groups[group_index]))
            qtile.groups[group_index].cmd_toscreen()
    except Exception as e:
        logger.error(str(e))
        logger.error(sys.exc_info())
        raise
    return lazy.function(callback)

keys = [
    # Switch between windows in current stack pane
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),

    # Move windows up or down in current stack
    Key([mod, "control"], "j", lazy.layout.shuffle_down()),
    Key([mod, "control"], "k", lazy.layout.shuffle_up()),
    Key([mod, "control"], "h", lazy.layout.shuffle_left()),
    Key([mod, "control"], "l", lazy.layout.shuffle_right()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
    Key([mod], "Return", lazy.spawn("kitty -e '/bin/zsh'")),
    Key([mod], "c", lazy.spawn("chromium")),
    Key([mod], "e", lazy.spawn("kitty -e 'nvim'")),
    Key([mod], "f", lazy.spawn("kitty -e 'ranger'")),
    Key([mod], "n", lazy.spawn("emacs /home/gergeh/work/notes/projects.org")),

    Key([mod], "i", lazy.spawn("emacsclient -e '(org-capture nil \"i\")'"), bring_group_to_front("Notes")),
    Key([mod], "v", lazy.spawn("pavucontrol")),
    Key([mod], "x", lazy.function(next_keyboard)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
]

group_names = [("WWW", {'layout': 'bsp'}, 0),
                ("WWW2", {'layout': 'bsp'}, 1),
               ("DEV", {'layout': 'max'}, 1),
               ("CMD", {'layout': 'bsp'}, 0),
               ("File", {'layout': 'treetab'}, 0),
               ("Notes", {'layout': 'max'}, 1),
               ("Misc", {'layout': 'treetab'}, 1),
               ("VMWare1", {'layout': 'floating'}, 0),
               ("VMware2", {'layout': 'floating'}, 1)] 

groups = [Group(name, **kwargs) for name, kwargs,_ in group_names]
screen_map = { name:screen_num for name, _,screen_num in group_names } 

@hook.subscribe.setgroup
def record_screen_assignments():
    try:
        from libqtile import qtile
    except ImportError as e:
        logger.error(str(e))
        return
    for i,(name,_,_) in enumerate(group_names):
        screen = client.group[name].info()['screen']
        if screen is not None:
            screen_map[name] = screen
    logger.error('setgroup')
    logger.error(screen_map)

@hook.subscribe.changegroup
def record_screen_assignments2():
    try:
        from libqtile import qtile
    except ImportError as e:
        logger.error(str(e))
        return
    for i,(name,_,_) in enumerate(group_names):
        screen = client.group[name].info()['screen']
        if screen is not None:
            screen_map[name] = screen
    logger.error('changegroup')
    logger.error(screen_map)




for i, group_t in enumerate(group_names, 1):
    name, kwargs, _ = group_t
#    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod], str(i), bring_group_to_front(name)))# Send current window to another group
    keys.append(Key([mod, "shift"], str(i), bring_group_to_screen(i-1)))        # Switch to another group
    keys.append(Key([mod, "control"], str(i), lazy.window.togroup(name))) # Send current window to another group


def current_window_to_screen_lazy_callback(screen_num:int):
    def callback(qtile):
        qtile.current_window.toscreen(screen_num)
    return lazy.function(callback)

for i,key in enumerate("asd"):
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], key, lazy.to_screen(i)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        # Key([mod, "shift"], key, lazy.window.toscreen(i))
    ])

layout_theme = {"border_width": 2,
                "margin": 5,
                "border_focus": "e1acff",
                "border_normal": "1D2330"
                }

layouts = [
    layout.bsp.Bsp(**layout_theme),
    layout.TreeTab(
         font = "Ubuntu",
         fontsize = 10,
         sections = ["FIRST", "SECOND"],
         section_fontsize = 11,
         bg_color = "141414",
         active_bg = "90C435",
         active_fg = "000000",
         inactive_bg = "384323",
         inactive_fg = "a0a0a0",
         padding_y = 5,
         section_top = 10,
         panel_width = 200,
         ),
    layout.Floating(**layout_theme),
    layout.Max()
]

screens = [
    Screen(top=top_bar(),bottom=bottom_bar()),
    Screen(top=top_bar(),bottom=bottom_bar()),
]
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see sevSdDZxHOF%e7hkGeral discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


# ----------------------------------------------------------------------------
# Hooks
@hook.subscribe.startup_complete
def autostart():
    """
    My startup script has a sleep in it as some of the commands depend on
    state from the rest of the init. This will cause start/restart of qtile
    to hang slightly as the sleep runs.
    """
    # os.environ.setdefault('RUNNING_QTILE', 'True')
    # run("xrandr --output DVI-D-1 --mode 1600x1200 --right-of HDMI-2 --output HDMI-2 --mode 2560x1080 --output HDMI-1 --mode 1920x1080 --right-of HDMI-2")
    # run("xrandr --output DVI-D-0 --mode 1600x1200 --right-of HDMI-2 --output HDMI-2 --mode 2560x1080")
    run("setxkbmap -option ctrl:ralt_rctrl")
    run("setxkbmap -option caps:swapescape")
    home = os.path.expanduser('~')
    run('sh ' + home + '/.config/qtile/autostart.sh')
    wifi_interface = "wlp5s0"
    run(f"wpa_supplicant -B -i {wifi_interface} -c /home/{username}/.config/wpa_supplicant/wpa_supplicant.conf")



@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    """
    Restart and reload config when screens are changed so that we correctly
    init any new screens and correctly remove any old screens that we no
    longer need.
    There is an annoying side effect of removing a second monitor that results
    in windows being 'stuck' on the now invisible desktop...
    """
    # qtile.cmd_restart()
    pass

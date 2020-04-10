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

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.lazy import lazy
from libqtile import layout, hook, bar, widget

from helper import run

from apperance import widget_defaults, extension_defaults
from apperance import top_bar, bottom_bar

# This has to be run this before screens are defined, so that it correctly picks up the order and resulotion
# run("xrandr --output DVI-D-1 --mode 1600x1200 --left-of HDMI-2 --output HDMI-2 --mode 2560x1080 --output HDMI-1 --mode 1920x1080 --right-of HDMI-2")

from typing import List  # noqa: F401

mod = "mod4"

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
    Key([mod], "Return", lazy.spawn("termite")),
    Key([mod], "c", lazy.spawn("chromium")),
    Key([mod], "e", lazy.spawn("emacs")),
    Key([mod], "v", lazy.spawn("pavucontrol")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),
]


groups = [
    Group(
        "1",
        label="A"
    ),
    Group(
        "2",
        label="B"
    ),
    Group(
        "3",
        label="C"
    ),
    Group(
        "c",
        matches=[Match(
            title=["chromium"],
            wm_class=["chromium"])],
        label=""
    ),
    Group(
        "e",
        matches=[Match(
            title=["Emacs"],
            wm_class=["Emacs"])],
        label=""
    ),
    Group(
        "t",
        matches=[Match(
            title=["termite"],
            wm_class=["termite"])],
        label=""
    ),
    # Group(
    #     "5",
    #     matches=[Match(wm_class=["Thunderbird"])],
    #     label=""
    # ),
    # Group(
    #   "6",
    #     matches=[Match(wm_class=["code-oss"])],
    #     label=""
    # ),
    # Group(
    #     "7",
    #     label=""
    # ),
    ]

# groups = [Group(c) for c in "asdfuiop"]

def current_window_to_screen_lazy_callback(screen_num:int):
    def callback(qtile):
        qtile.current_window.toscreen(screen_num)
    return lazy.funciton(callback)

for i,key in enumerate("asd"):
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], key, lazy.to_screen(i)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], key, lazy.window.toscreen(i))
    ])

# layouts = [
#     layout.Max(),
#     layout.Stack(num_stacks=2),
#     # Try more layouts by unleashing below layouts.
#     # layout.Bsp(),
#     # layout.Columns(),
#     # layout.Matrix(),
#     # layout.MonadTall(),
#     # layout.MonadWide(),
#     # layout.RatioTile(),
#     # layout.Tile(),
#     # layout.TreeTab(),
#     # layout.VerticalTile(),
#     # layout.Zoomy(),
# ]
layouts = [
    layout.bsp.Bsp()
]

screens = [
    Screen(top=top_bar(),bottom=bottom_bar()),
    Screen(),
    Screen(top=top_bar())
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
# string besides java UI toolkits; you can see several discussions on the
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
    # run("xrandr --output DVI-D-1 --mode 1600x1200 --left-of HDMI-2 --output HDMI-2 --mode 2560x1080 --output HDMI-1 --mode 1920x1080 --right-of HDMI-2")
    run("setxkbmap -option ctrl:ralt_rctrl")
    run("setxkbmap -option caps:swapescape")



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

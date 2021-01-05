from libqtile import layout, bar, widget, hook
import os
import socket

myTerm = "termite"                             # My terminal of choice
myConfig = "/home/gergeh/.config/qtile/config.py"    # The Qtile config file location


colors = {'dark-grey-blue':'2e3440',
            'dark-purple':'511845',
          'dark-red':'900c3f',
          'red':'c70039',
          'orange':'ff5733',
          'very-soft-red':'e0aca2',
          'deep-blue':'30345F'}

import memory_widget
widget_defaults = dict(
    font='Fira Mono',
    fontsize=14,
    padding=4,
    background=colors['deep-blue'],
    foreground=colors['very-soft-red'],
)
extension_defaults = widget_defaults.copy()

BAR_HEIGHT = 20


def top_bar():
    return bar.Bar([
        widget.Spacer(),
        widget.Systray(),
        widget.Clock(
            format='%b-%d %a %H:%M'
        ),
    ],
                   size=BAR_HEIGHT,
                    background=colors['deep-blue'],
                   )

keyboard_widget = widget.KeyboardLayout(configured_keyboards=['us','hu'])

def bottom_bar():
    return bar.Bar([
        widget.HDDBusyGraph(device='nvme0n1p1'),
        widget.CPU(format='CPU {load_percent}%'),
        memory_widget.Memory(),
        widget.Net(format='{down} ↓↑ {up}'),
        widget.CheckUpdates(custom_command="checkupdates"),
        widget.KeyboardLayout(configured_keyboards=['us','hu']),
        widget.Spacer(),
        widget.GroupBox(inactive=colors['very-soft-red']),
        widget.Prompt(),
    ],
                   size=BAR_HEIGHT,
                    background=colors['deep-blue'],
                   )


# colors = [["#292d3e", "#292d3e"], # panel background
#           ["#434758", "#434758"], # background for current screen tab
#           ["#ffffff", "#ffffff"], # font color for group names
#           ["#ff5555", "#ff5555"], # border line color for current tab
#           ["#8d62a9", "#8d62a9"], # border line color for other tab and odd widgets
#           ["#668bd7", "#668bd7"], # color for the even widgets
#           ["#e1acff", "#e1acff"]] # window name

# prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

# ##### DEFAULT WIDGET SETTINGS #####
# widget_defaults = dict(
#     font="Fira Mono",
#     fontsize = 12,
#     padding = 2,
#     background=colors[2]
# )
# extension_defaults = widget_defaults.copy()

# def init_widgets_list():
#     widgets_list = [
#               widget.sep.Sep(
#                        linewidth = 0,
#                        padding = 6,
#                        foreground = colors[2],
#                        background = colors[0]
#                        ),
#               widget.image.Image(
#                        filename = "~/.config/qtile/icons/python.png",
#                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('dmenu_run')}
#                        ),
#               widget.GroupBox(
#                        font = "Ubuntu Bold",
#                        fontsize = 9,
#                        margin_y = 3,
#                        margin_x = 0,
#                        padding_y = 5,
#                        padding_x = 3,
#                        borderwidth = 3,
#                        active = colors[2],
#                        inactive = colors[2],
#                        rounded = False,
#                        highlight_color = colors[1],
#                        highlight_method = "line",
#                        this_current_screen_border = colors[3],
#                        this_screen_border = colors [4],
#                        other_current_screen_border = colors[0],
#                        other_screen_border = colors[0],
#                        foreground = colors[2],
#                        background = colors[0]
#                        ),
#               widget.Prompt(
#                        prompt = prompt,
#                        font = "Ubuntu Mono",
#                        padding = 10,
#                        foreground = colors[3],
#                        background = colors[1]
#                        ),
#               widget.sep.Sep(
#                        linewidth = 0,
#                        padding = 40,
#                        foreground = colors[2],
#                        background = colors[0]
#                        ),
#               widget.WindowName(
#                        foreground = colors[6],
#                        background = colors[0],
#                        padding = 0
#                        ),
#               widget.TextBox(
#                        text = '',
#                        background = colors[0],
#                        foreground = colors[4],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.TextBox(
#                        text = " 🌡",
#                        padding = 2,
#                        foreground = colors[2],
#                        background = colors[5],
#                        fontsize = 11
#                        ),
#               widget.sensors.ThermalSensor(
#                        foreground = colors[2],
#                        background = colors[5],
#                        threshold = 90,
#                        padding = 5
#                        ),
#               widget.TextBox(
#                        text='',
#                        background = colors[5],
#                        foreground = colors[4],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.TextBox(
#                        text = " ⟳",
#                        padding = 2,
#                        foreground = colors[2],
#                        background = colors[4],
#                        fontsize = 14
#                        ),
#               widget.pacman.Pacman(
#                        update_interval = 1800,
#                        foreground = colors[2],
#                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')},
#                        background = colors[4]
#                        ),
#               widget.TextBox(
#                        text = "Updates",
#                        padding = 5,
#                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e sudo pacman -Syu')},
#                        foreground = colors[2],
#                        background = colors[4]
#                        ),
#               widget.TextBox(
#                        text = '',
#                        background = colors[4],
#                        foreground = colors[5],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.TextBox(
#                        text = " 🖬",
#                        foreground = colors[2],
#                        background = colors[5],
#                        padding = 0,
#                        fontsize = 14
#                        ),
#               memory_widget.Memory(
#                        foreground = colors[2],
#                        background = colors[5],
#                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e htop')},
#                        padding = 5
#                        ),
#               widget.TextBox(
#                        text='',
#                        background = colors[5],
#                        foreground = colors[4],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.net.Net(
#                        interface = "enp6s0",
#                        format = '{down} ↓↑ {up}',
#                        foreground = colors[2],
#                        background = colors[4],
#                        padding = 5
#                        ),
#               widget.TextBox(
#                        text = '',
#                        background = colors[4],
#                        foreground = colors[5],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.TextBox(
#                       text = " Vol:",
#                        foreground = colors[2],
#                        background = colors[5],
#                        padding = 0
#                        ),
#               widget.volume.Volume(
#                        foreground = colors[2],
#                        background = colors[5],
#                        padding = 5
#                        ),
#               widget.TextBox(
#                        text = '',
#                        background = colors[5],
#                        foreground = colors[4],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.CurrentLayoutIcon(
#                        custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
#                        foreground = colors[0],
#                        background = colors[4],
#                        padding = 0,
#                        scale = 0.7
#                        ),
#               widget.CurrentLayout(
#                        foreground = colors[2],
#                        background = colors[4],
#                        padding = 5
#                        ),
#               widget.TextBox(
#                        text = '',
#                        background = colors[4],
#                        foreground = colors[5],
#                        padding = 0,
#                        fontsize = 37
#                        ),
#               widget.Clock(
#                        foreground = colors[2],
#                        background = colors[5],
#                        format = "%A, %B %d  [ %H:%M ]"
#                        ),
#               widget.sep.Sep(
#                        linewidth = 0,
#                        padding = 10,
#                        foreground = colors[0],
#                        background = colors[5]
#                        ),
#               widget.Systray(
#                        background = colors[0],
#                        padding = 5
#                        ),
#               ]
#     return widgets_list

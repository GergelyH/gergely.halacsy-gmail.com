from libqtile import layout, bar, widget, hook

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
        widget.spacer.Spacer(),
        widget.systray.Systray(),
        widget.Clock(
            format='%b-%d %a %H:%M'
        ),
    ],
                   size=BAR_HEIGHT,
                    background=colors['deep-blue'],
                   )

keyboard_widget = widget.keyboardlayout.KeyboardLayout(configured_keyboards=['us','hu'])

def bottom_bar():
    return bar.Bar([
        widget.graph.HDDBusyGraph(device='nvme0n1p1'),
        widget.cpu.CPU(format='CPU {load_percent}%'),
        memory_widget.Memory(),
        widget.net.Net(format='{down} ↓↑ {up}'),
        widget.check_updates.CheckUpdates(custom_command="checkupdates"),
        widget.keyboardlayout.KeyboardLayout(configured_keyboards=['us','hu']),
        widget.spacer.Spacer(),
        widget.groupbox.GroupBox(),
        widget.prompt.Prompt(),
    ],
                   size=BAR_HEIGHT,
                    background=colors['deep-blue'],
                   )

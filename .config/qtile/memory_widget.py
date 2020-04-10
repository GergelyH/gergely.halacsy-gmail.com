# -*- coding: utf-8 -*-
import psutil

from libqtile.widget import base

__all__ = ["Memory"]


class Memory(base.ThreadedPollText):
    """Displays memory/swap usage

    MemUsed: Returns memory in use
    MemTotal: Returns total amount of memory
    MemFree: Returns amount of memory free
    Buffers: Returns buffer amount
    Active: Returns active memory
    Inactive: Returns inactive memory
    Shmem: Returns shared memory
    SwapTotal: Returns total amount of swap
    SwapFree: Returns amount of swap free
    SwapUsed: Returns amount of swap in use
"""

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("format", "{MemUsed:.1f}G/{MemTotal:.1f}G", "Formatting for field names."),
        ("update_interval", 1.0, "Update interval for the Memory"),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(Memory.defaults)

    def tick(self):
        self.update(self.poll())
        return self.update_interval

    def poll(self):
        mem = psutil.virtual_memory()
        swap = psutil.swap_memory()
        val = {}
        val["MemUsed"] = mem.used // 1024 // 1024 / 1024
        val["MemTotal"] = mem.total // 1024 // 1024 / 1024
        val["MemFree"] = mem.free // 1024 // 1024 / 1024
        val["Buffers"] = mem.buffers // 1024 // 1024 / 1024
        val["Active"] = mem.active // 1024 // 1024 / 1024
        val["Inactive"] = mem.inactive // 1024 // 1024 / 1024
        val["Shmem"] = mem.shared // 1024 // 1024 / 1024
        val["SwapTotal"] = swap.total // 1024 // 1024 / 1024
        val["Swapfree"] = swap.free // 1024 // 1024 / 1024
        val["SwapUsed"] = swap.used // 1024 // 1024 / 1024
        return self.format.format(**val)

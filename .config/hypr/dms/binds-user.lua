-- DMS user keybind overrides (edit via Control Center or dms; do not remove this header)

hl.unbind("SUPER + R")
hl.bind("SUPER + R", hl.dsp.exec_cmd("dms ipc call spotlight toggle"), { description = "dms ipc call spotlight toggle" })
hl.unbind("SUPER + Q")
hl.unbind("SUPER + W")
hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close window" })

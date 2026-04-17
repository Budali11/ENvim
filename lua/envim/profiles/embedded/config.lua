return {
  toolchain = {
    gdb = "arm-none-eabi-gdb",
    openocd = "openocd",
  },
  dap = {
    gdb_target = "localhost:3333",
    openocd_args = {},
    stop_at_entry = false,
  },
  tasks = {
    build = "make",
    flash = nil,
    monitor = nil,
  },
}

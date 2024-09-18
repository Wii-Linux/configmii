# configmii - the Wii Linux configuration program

This program aims to, in the future, be a basic TUI app to let you configure the following settings.

- Bootup procedure
  - Kernel command line
  - Initrd loader settings (spefic args on the cmdline)
  - Loader.img settings (specific args on the cmdline)
- Userspace settings
  - Switch between Xorg fbdev (max compatibility, slow), or once created, a customized Flipper/Hollywood driver (lower compatibility due to not supporting all OpenGL features, even through a compatibility layer, but fast)
  - Select an mirror to use for Wii Linux packages (EU, US, or Canada).
  - TODO, maybe a simple "Update OS" button?


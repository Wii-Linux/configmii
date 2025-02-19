# configmii - the Wii Linux configuration program

This program is a basic TUI app to let you configure the following settings:

- Userspace settings
  - Configure the login banner
  - Manage ArchPOWER packages
    - Update the system
    - Cleanup orphaned packages
    - Clear the cache
    - Toggle the 'testing' repos
  - Install a desktop environment


Additionally, the following features would like to be added in the future:
- Bootup procedure
  - Kernel command line
  - Initrd loader settings (spefic args on the cmdline)
  - Loader.img settings (specific args on the cmdline)
- Userspace settings
  - Switch between Xorg fbdev (max compatibility, slow), or once created, a customized Flipper/Hollywood driver (lower compatibility due to not supporting all OpenGL features, even through a compatibility layer, but fast)
  - Select an mirror to use for Wii Linux packages (EU, US, or Canada).

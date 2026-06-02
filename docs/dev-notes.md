# Development Notes

These notes document KDE Plasma 6 Wayland caveats for future script implementation. They are not implementation instructions yet.

## KDE Plasma 6 Settings

KDE Plasma 6 uses Qt 6 tooling. Prefer Plasma 6 commands and files where possible:

- `kwriteconfig6` for writing KDE config values
- `kreadconfig6` for reading KDE config values
- `lookandfeeltool` for applying Plasma global themes

Some older examples online use Plasma 5 commands or paths. Verify that commands target Plasma 6 before copying any approach into this project.

## Desktop Themes and Color Schemes

Plasma settings are split across several concepts:

- Global theme / look-and-feel package
- Plasma desktop theme
- Application style
- Color scheme
- Icon theme
- Cursor theme
- Wallpaper

Changing only one of these may not fully reproduce a desktop appearance. A saved theme should eventually track the specific files and metadata needed for each layer.

## `kwriteconfig6` vs Theme Tools

`kwriteconfig6` is useful for direct config writes, but it does not always trigger the same live refresh behavior as using KDE's theme tools.

Future implementation should treat these as separate operations:

- Copy config snapshots for persistence.
- Apply named theme settings with KDE tools when available.
- Trigger refresh or restart steps only where needed.

## Restarting Plasma Components

Restarting `plasmashell` can refresh panels, widgets, and wallpaper state, but it should be done carefully on Wayland.

Future scripts should avoid killing broad desktop sessions. Prefer targeted Plasma component restarts or DBus/KDE commands where available. If `plasmashell` must restart, the script should make that step clear and recover cleanly.

## KWin on Wayland

KWin Wayland owns compositor state, effects, window rules, and some input/display behavior. Some KWin settings may not apply instantly after copying `kwinrc`.

Future theme switching should avoid risky display/session operations. Theme switching should focus on visual configuration, not monitor layout, refresh rate, or hardware-specific state unless explicitly supported later.

## GTK Themes Under Wayland

GTK applications on Wayland may read settings from several places:

- GTK config files
- XDG desktop portal settings
- Environment variables
- KDE integration settings

Future scripts may need to consider variables such as:

```fish
set -gx GTK_THEME Breeze-Dark
```

This should be handled carefully because environment variables set in one shell do not automatically update already-running graphical applications.

## Qt and KDE Theme Names

Qt style names, KDE color scheme names, Plasma desktop theme names, and look-and-feel package names are not always identical.

The `.meta` file keeps these as separate keys so the future switcher can apply each one intentionally.

## Wallpapers

Wallpaper settings in Plasma are stored inside applet configuration. The same wallpaper may need to be referenced through Plasma shell config rather than only copied to a directory.

Future implementation should account for per-activity and per-screen wallpaper state.

## Fish Compatibility

This project targets fish shell behavior for future shared functions under `scripts/lib/`.

Any future shell snippets should avoid bash-only syntax such as arrays with parentheses, `[[ ... ]]`, `${var}`, and `source` assumptions that do not match fish behavior.

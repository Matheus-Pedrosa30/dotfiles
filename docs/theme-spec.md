# Theme Specification

Theme directories live under `config/themes/`. Each direct child directory represents one saved desktop theme.

Example:

```text
config/themes/example-theme/
├── .meta
├── gtk/
├── kde/
├── kitty/
├── kvantum/
└── wallpaper/
```

## `.meta` File

The `.meta` file stores human-readable theme metadata and the main theme names needed when applying settings.

Format:

- One `key=value` pair per line.
- Keys are lowercase and may use hyphens.
- Values are plain text.
- Empty values are allowed when a setting is optional or unknown.
- Paths are relative to the theme directory unless documented otherwise.

Example:

```text
name=MacOS Dark
author=Matheus
gtk-theme=Breeze-Dark
icon-theme=kora
cursor-theme=McMojave
cursor-size=24
qt-theme=MacTahoeDark
color-scheme=MacTahoe-Dark
look-and-feel=
wallpaper=wallpaper/wallpaper.jpg
```

## Metadata Keys

`name`

Display name shown by `switch-theme.sh`.

`author`

Person who saved or maintains the theme.

`gtk-theme`

GTK theme name to apply for GTK applications.

`icon-theme`

Icon theme name to apply.

`cursor-theme`

Cursor theme name to apply.

`cursor-size`

Cursor size in pixels.

`qt-theme`

Qt widget style or theme name. On KDE Plasma this may map to a theme handled by Plasma settings rather than a standalone Qt setting.

`color-scheme`

KDE color scheme name, such as `BreezeDark` or `MacTahoe-Dark`.

`look-and-feel`

Optional Plasma global theme package name for `lookandfeeltool`.

`wallpaper`

Relative path to the primary wallpaper file inside the theme directory.

## `kde/`

Expected to contain KDE Plasma and KWin configuration snapshots.

Examples of files that may belong here:

- `kdeglobals`
- `kwinrc`
- `plasmarc`
- `plasma-org.kde.plasma.desktop-appletsrc`
- `kscreenlockerrc`
- `kcminputrc`

This directory is for KDE-owned config files that normally live in `~/.config/`.

## `gtk/`

Expected to contain GTK configuration snapshots.

Examples:

- `settings.ini` from GTK 3 config
- GTK 4 settings files, if present
- Theme-related environment notes, if needed later

This directory should store GTK settings files, not installed GTK theme assets.

## `kvantum/`

Expected to contain Kvantum configuration for the saved theme.

Examples:

- `kvantum.kvconfig`
- Theme-specific Kvantum config directories, when needed

This directory should store user-level Kvantum configuration, not system package files.

## `kitty/`

Expected to contain kitty configuration snapshots.

Examples:

- `kitty.conf`
- Included theme files
- Font and color settings

This directory is for terminal appearance settings associated with the saved desktop theme.

## `wallpaper/`

Expected to contain wallpaper files referenced by `.meta`.

Recommended names:

- `wallpaper.jpg`
- `wallpaper.webp`
- `wallpaper.png`

PNG wallpapers are ignored by default in `.gitignore` because they can become large. Remove that ignore rule if PNG wallpaper files should be versioned.

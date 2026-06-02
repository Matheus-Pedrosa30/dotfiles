# KDE Wayland Theme Switcher Dotfiles

A personal Linux dotfiles project for saving and switching KDE Plasma theme states on Wayland. The goal is to snapshot the files and settings that make up a desktop look, store them under `config/themes/`, and later apply one of those saved themes from a simple terminal menu.

This repository currently contains documentation and folder structure only. The root scripts are placeholders and do not implement any behavior yet.

## Compatibility

Designed for:

- CachyOS or another Arch-based Linux distribution
- KDE Plasma 6+
- KWin on Wayland
- fish shell
- kitty terminal

Reference setup:

- KDE Plasma 6.6.5 / KWin Wayland
- fish 4.7.1
- kitty 0.47.1
- 1920x1080 display at 120Hz

Other KDE Plasma 6 Wayland systems should be possible, but paths, theme names, and reload behavior may need local adjustment.

## Folder Structure

```text
.
├── README.md
├── .gitignore
├── save.sh
├── switch-theme.sh
├── config
│   └── themes
│       └── example-theme
│           ├── .meta
│           ├── gtk
│           │   └── .gitkeep
│           ├── kde
│           │   └── .gitkeep
│           ├── kitty
│           │   └── .gitkeep
│           ├── kvantum
│           │   └── .gitkeep
│           └── wallpaper
│               └── .gitkeep
├── docs
│   ├── dev-notes.md
│   └── theme-spec.md
└── scripts
    └── lib
        └── .gitkeep
```

## How `save.sh` Works

Conceptually, `save.sh` will save the current desktop state as a named theme.

Expected flow:

1. Prompt for a theme name.
2. Normalize that name into a directory name under `config/themes/`.
3. Create the expected theme subdirectories.
4. Copy KDE Plasma, GTK, Kvantum, kitty, and wallpaper configuration files into the theme directory.
5. Write or update the theme `.meta` file.

The script should behave like "save current state" rather than "generate a theme from scratch". It should copy the files that already represent the current desktop configuration.

No implementation exists yet.

## How `switch-theme.sh` Works

Conceptually, `switch-theme.sh` will apply one of the saved themes.

Expected flow:

1. Read all subdirectories inside `config/themes/`.
2. Display a numbered list using each theme's display name from `.meta`.
3. Prompt for a selection.
4. Copy the selected theme's stored config files into the appropriate user config locations.
5. Apply KDE, GTK, Qt, icon, cursor, kitty, Kvantum, and wallpaper settings.
6. Reload or restart the relevant Plasma services when needed.

Example menu:

```text
[1] MacOS Dark
[2] MacOS Liquid Glass
[3] Windows

Select a theme:
```

No implementation exists yet.

## Theme Metadata

Each theme directory contains a `.meta` file using a simple `key=value` format.

Example:

```text
name=Example Theme
author=Matheus
gtk-theme=Breeze
icon-theme=kora
cursor-theme=McMojave
cursor-size=24
qt-theme=MacTahoeDark
color-scheme=MacTahoe-Dark
look-and-feel=
wallpaper=wallpaper/wallpaper.jpg
```

See [docs/theme-spec.md](/home/matheusp/Projetos/dotfiles/docs/theme-spec.md) for the full schema notes.

## Manual Prerequisites

Install the tools that future scripts are expected to use:

- `rsync`
- `plasma-theme`
- `lookandfeeltool`
- `kwriteconfig6`
- `fish`

On an Arch-based system, package names may differ slightly depending on repository packaging and installed Plasma components.

## Roadmap

- Implement `save.sh` using fish-compatible shell behavior.
- Implement `switch-theme.sh` with a numbered terminal menu.
- Add validation for missing `.meta` keys and missing config files.
- Add rofi or wofi menu support.
- Add Waybar support for non-Plasma panels.
- Add automatic screenshot capture when saving a theme.
- Add optional wallpaper previews.
- Add rollback support before applying a new theme.

## Screenshots

> screenshots coming soon

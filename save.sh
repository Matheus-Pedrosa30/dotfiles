#!/usr/bin/env fish

set SCRIPT_PATH (realpath (status filename))
set REPO_ROOT (path dirname $SCRIPT_PATH)
set THEMES_DIR "$REPO_ROOT/config/themes"
set CONFIG_DIR "$HOME/.config"

function print_copied
    set rel_path $argv[1]
    echo "  ✓ $rel_path"
end

function print_skipped
    set rel_path $argv[1]
    echo "  – $rel_path (not found, skipping)"
end

function slugify
    set raw_name $argv[1]
    set slug (string lower -- "$raw_name")
    set slug (string replace -ra '[^a-z0-9[:space:]-]' '' -- "$slug")
    set slug (string replace -ra '[[:space:]]+' '-' -- "$slug")
    set slug (string replace -ra '-+' '-' -- "$slug")
    set slug (string trim --chars '-' -- "$slug")
    echo "$slug"
end

function read_kde_config
    set file_name $argv[1]
    set group_name $argv[2]
    set key_name $argv[3]

    if command -q kreadconfig6
        set value (kreadconfig6 --file "$file_name" --group "$group_name" --key "$key_name" 2>/dev/null)
        echo "$value"
    else
        echo ""
    end
end

function read_gtk_theme
    set settings_file "$CONFIG_DIR/gtk-3.0/settings.ini"
    if test -e "$settings_file"
        set value (grep '^gtk-theme-name=' "$settings_file" | string replace 'gtk-theme-name=' '')
        echo "$value"
    else
        echo ""
    end
end

function copy_file_if_exists
    set source_path $argv[1]
    set dest_path $argv[2]
    set rel_path $argv[3]

    if test -e "$source_path"
        mkdir -p (path dirname "$dest_path")
        cp "$source_path" "$dest_path"
        print_copied "$rel_path"
    else
        print_skipped "$rel_path"
    end
end

echo -n "Theme name: "
read theme_name
set theme_name (string trim -- "$theme_name")

if test -z "$theme_name"
    echo "Theme name cannot be empty."
    exit 1
end

set theme_slug (slugify "$theme_name")

if test -z "$theme_slug"
    echo "Theme slug would be empty. Use a name with letters or numbers."
    exit 1
end

set theme_dir "$THEMES_DIR/$theme_slug"

if test -e "$theme_dir"
    echo -n "Theme '$theme_slug' already exists. [o]verwrite / [c]ancel? "
    read overwrite_choice
    set overwrite_choice (string lower -- (string trim -- "$overwrite_choice"))

    if test "$overwrite_choice" != "o"
        echo "Cancelled."
        exit 0
    end

    rm -rf "$theme_dir"
end

mkdir -p "$theme_dir/kde" "$theme_dir/gtk" "$theme_dir/kvantum" "$theme_dir/kitty" "$theme_dir/wallpaper"

set wallpaper_meta ""
echo -n "Wallpaper path (leave blank to skip): "
read wallpaper_path
set wallpaper_path (string trim -- "$wallpaper_path")

echo
echo "Saving theme '$theme_name' as '$theme_slug'..."
echo

set kde_files \
    kdeglobals \
    plasmarc \
    kwinrc \
    breezerc \
    kwindecorationrc \
    kcmfonts \
    kcminputrc \
    kscreenlockerrc \
    ksplashrc \
    klaunchrc \
    Trolltech.conf \
    plasma-org.kde.plasma.desktop-appletsrc

for file_name in $kde_files
    copy_file_if_exists "$CONFIG_DIR/$file_name" "$theme_dir/kde/$file_name" "kde/$file_name"
end

if test -e "$CONFIG_DIR/plasma-org.kde.plasma.desktop-appletsrc"
    echo "  ! kde/plasma-org.kde.plasma.desktop-appletsrc may contain wallpaper path references that can break on restore"
end

echo -n "Save global shortcuts? [y/N] "
read shortcuts_choice
set shortcuts_choice (string lower -- (string trim -- "$shortcuts_choice"))

if test "$shortcuts_choice" = "y"
    copy_file_if_exists "$CONFIG_DIR/kglobalshortcutsrc" "$theme_dir/kde/kglobalshortcutsrc" "kde/kglobalshortcutsrc"
else
    echo "  – kde/kglobalshortcutsrc (skipped by user)"
end

copy_file_if_exists "$CONFIG_DIR/gtk-3.0/settings.ini" "$theme_dir/gtk/gtk-3.0/settings.ini" "gtk/gtk-3.0/settings.ini"
copy_file_if_exists "$CONFIG_DIR/gtk-4.0/settings.ini" "$theme_dir/gtk/gtk-4.0/settings.ini" "gtk/gtk-4.0/settings.ini"
copy_file_if_exists "$CONFIG_DIR/gtkrc" "$theme_dir/gtk/gtkrc" "gtk/gtkrc"
copy_file_if_exists "$CONFIG_DIR/gtkrc-2.0" "$theme_dir/gtk/gtkrc-2.0" "gtk/gtkrc-2.0"

if test -e "$CONFIG_DIR/Kvantum"
    cp -r "$CONFIG_DIR/Kvantum/." "$theme_dir/kvantum"
    for copied_file in $theme_dir/kvantum/**
        test -f "$copied_file" || continue
        set copied_rel (string replace "$theme_dir/" "" -- "$copied_file")
        print_copied "$copied_rel"
    end
else
    print_skipped "kvantum/kvantum.kvconfig"
end

copy_file_if_exists "$CONFIG_DIR/kitty/kitty.conf" "$theme_dir/kitty/kitty.conf" "kitty/kitty.conf"

if test -d "$CONFIG_DIR/kitty"
    for include_file in $CONFIG_DIR/kitty/*.conf
        test -e "$include_file" || continue
        set include_name (path basename "$include_file")
        if test "$include_name" != "kitty.conf"
            copy_file_if_exists "$include_file" "$theme_dir/kitty/$include_name" "kitty/$include_name"
        end
    end
end

if test -n "$wallpaper_path"
    if test -e "$wallpaper_path"
        set wallpaper_ext (path extension "$wallpaper_path")

        if test -z "$wallpaper_ext"
            set wallpaper_ext ".jpg"
        end

        set wallpaper_dest "wallpaper/wallpaper$wallpaper_ext"
        cp "$wallpaper_path" "$theme_dir/$wallpaper_dest"
        set wallpaper_meta "$wallpaper_dest"
        print_copied "$wallpaper_dest"
    else
        echo "  – wallpaper (provided path not found, skipping)"
    end
else
    echo "  – wallpaper (skipped by user)"
end

set icon_theme (read_kde_config kdeglobals Icons Theme)
set qt_theme (read_kde_config kdeglobals KDE widgetStyle)
set color_scheme (read_kde_config kdeglobals General ColorScheme)
set cursor_theme (read_kde_config kcminputrc Mouse cursorTheme)
set cursor_size (read_kde_config kcminputrc Mouse cursorSize)
set gtk_theme (read_gtk_theme)

set meta_file "$theme_dir/.meta"

printf 'name=%s\n' "$theme_name" > "$meta_file"
printf 'author=%s\n' "$USER" >> "$meta_file"
printf 'gtk-theme=%s\n' "$gtk_theme" >> "$meta_file"
printf 'icon-theme=%s\n' "$icon_theme" >> "$meta_file"
printf 'cursor-theme=%s\n' "$cursor_theme" >> "$meta_file"
printf 'cursor-size=%s\n' "$cursor_size" >> "$meta_file"
printf 'qt-theme=%s\n' "$qt_theme" >> "$meta_file"
printf 'color-scheme=%s\n' "$color_scheme" >> "$meta_file"
printf 'look-and-feel=\n' >> "$meta_file"
printf 'wallpaper=%s\n' "$wallpaper_meta" >> "$meta_file"

echo
echo "Saved theme directory:"
echo "  $theme_dir"
echo
echo ".meta:"
cat "$meta_file"

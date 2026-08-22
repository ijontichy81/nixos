#!/usr/bin/env bash

FLAKE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IS_LIGHT_FILE="$FLAKE_DIR/assets/is-light"
CONFIG_FILE="$FLAKE_DIR/assets/theme-config.env"
INTERACTIVE=false

[ -t 0 ] && INTERACTIVE=true
[[ "$1" == "-i" || "$1" == "--interactive" ]] && INTERACTIVE=true

FLAVORS=(latte frappe macchiato mocha)
ACCENTS=(mauve peach sapphire blue flamingo green lavender maroon pink red rosewater sky teal yellow)

pick() {
    local prompt="$1" ; shift
    local items=("$@") i sel
    while true; do
        echo "$prompt" >&2
        for i in "${!items[@]}"; do
            printf "  %d) %s\n" $((i+1)) "${items[i]}" >&2
        done
        printf "Choice [1-%d]: " "${#items[@]}" >&2
        read -r sel || return 1
        if [[ "$sel" =~ ^[0-9]+$ ]] && (( sel >= 1 && sel <= ${#items[@]} )); then
            echo "$((sel-1))"
            return 0
        fi
        echo "Invalid selection." >&2
    done
}

get_num() {
    local prompt="$1" default="$2" val
    while true; do
        read -r -p "$prompt [$default]: " val || { echo "$default"; return 0; }
        val="${val:-$default}"
        if [[ "$val" =~ ^[0-9]+$ ]] && (( val > 0 )); then
            echo "$val"
            return 0
        fi
        echo "Enter a positive number." >&2
    done
}

update_or_append() {
    local file="$1" key="$2" value="$3"
    if grep -q "^${key}=" "$file" 2>/dev/null; then
        sed -i "s|^${key}=.*|${key}=${value}|" "$file"
    else
        echo "${key}=${value}" >> "$file"
    fi
}

load_config() {
    [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
    FLAVOR="${CURSOR_FLAVOR:-macchiato}"
    ACCENT="${CURSOR_ACCENT:-mauve}"
    CURSOR_SIZE="${CURSOR_SIZE:-28}"
    FONT_SIZE="${FONT_SIZE:-11}"
    CURSOR_THEME="catppuccin-${FLAVOR}-${ACCENT}-cursors"
}

# ─── Detect current mode ───
[ -f "$IS_LIGHT_FILE" ] && CUR_MODE="light" || CUR_MODE="dark"

if $INTERACTIVE; then
    # ── Interactive mode ──
    echo "=============================="
    echo "  Catppuccin Theme Configurator"
    echo "=============================="
    echo "Current mode: $CUR_MODE"
    echo ""
    echo "Mode:"
    echo "  1) Toggle ($([ "$CUR_MODE" = "light" ] && echo "→ dark" || echo "→ light"))"
    echo "  2) Light"
    echo "  3) Dark"
    read -r mode_sel
    case "$mode_sel" in
        1) MODE="$([ "$CUR_MODE" = "light" ] && echo "dark" || echo "light")" ;;
        2) MODE="light" ;;
        3) MODE="dark" ;;
        *) MODE="$CUR_MODE" ;;
    esac

    echo ""
    FLAVOR_IDX=$(pick "Cursor flavor:" "${FLAVORS[@]}") || FLAVOR_IDX=2
    FLAVOR="${FLAVORS[$FLAVOR_IDX]}"

    echo ""
    ACCENT_IDX=$(pick "Cursor accent:" "${ACCENTS[@]}") || ACCENT_IDX=0
    ACCENT="${ACCENTS[$ACCENT_IDX]}"

    CURSOR_THEME="catppuccin-${FLAVOR}-${ACCENT}-cursors"

    CURSOR_SIZE=$(get_num "Cursor size (px)" 28)
    FONT_SIZE=$(get_num "GTK font size" 11)
else
    # ── Non-interactive toggle (keybind) ──
    load_config
    [ "$CUR_MODE" = "light" ] && MODE="dark" || MODE="light"
fi

# ─── Apply ───
if $INTERACTIVE; then
    echo "Applying..." >&2
fi

if [ "$MODE" = "light" ]; then
    touch "$IS_LIGHT_FILE"
else
    rm -f "$IS_LIGHT_FILE"
fi

caelestia scheme set -m "$MODE" </dev/null &>/dev/null &

for dir in ~/.config/gtk-3.0 ~/.config/gtk-4.0; do
    ini="$dir/settings.ini"
    [ -f "$ini" ] || continue
    if [ "$MODE" = "dark" ]; then
        sed -i 's/gtk-application-prefer-dark-theme=0/gtk-application-prefer-dark-theme=1/' "$ini"
    else
        sed -i 's/gtk-application-prefer-dark-theme=1/gtk-application-prefer-dark-theme=0/' "$ini"
    fi
    update_or_append "$ini" "gtk-cursor-theme-name" "$CURSOR_THEME"
    update_or_append "$ini" "gtk-font-name" "FiraCode Nerd Font $FONT_SIZE"
done

dconf write /org/gnome/desktop/interface/cursor-theme "'$CURSOR_THEME'" &>/dev/null
hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE" &>/dev/null

if [ "$MODE" = "dark" ]; then
    hyprctl keyword general:col.active_border "rgba(cba6f7ee) rgba(89b4faee) 45deg" &>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(585b70aa)" &>/dev/null
else
    hyprctl keyword general:col.active_border "rgba(8839efee) rgba(04a5e5ee) 45deg" &>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(9ca0b0aa)" &>/dev/null
fi

cat > "$CONFIG_FILE" << EOF
MODE=$MODE
CURSOR_FLAVOR=$FLAVOR
CURSOR_ACCENT=$ACCENT
CURSOR_THEME=$CURSOR_THEME
CURSOR_SIZE=$CURSOR_SIZE
FONT_SIZE=$FONT_SIZE
EOF

pkill nautilus 2>/dev/null

echo ""
echo "Done!"
echo "  Mode:   $MODE"
echo "  Cursor: $CURSOR_THEME (${CURSOR_SIZE}px)"
echo "  Font:   ${FONT_SIZE}pt"

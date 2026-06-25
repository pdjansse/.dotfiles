: "${PLUG_HOME:=${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins}"
typeset -gaU PLUG_LOADED

_plug_source_entrypoint() {
    emulate -L zsh
    setopt local_options null_glob

    local plugin_dir="$1"
    local plugin_name="$2"
    local init_file
    local -a init_files=(
        "$plugin_dir/${plugin_name}.plugin.zsh"
        "$plugin_dir/${plugin_name}.zsh"
        "$plugin_dir/${plugin_name}.zsh-theme"
        "$plugin_dir"/*.plugin.zsh(N)
        "$plugin_dir"/*.zsh(N)
        "$plugin_dir"/*.zsh-theme(N)
    )

    for init_file in "${init_files[@]}"; do
        if [[ -r "$init_file" ]]; then
            source "$init_file"
            PLUG_LOADED+=("$plugin_name")
            return 0
        fi
    done

    print -ru2 "plug: no plugin entrypoint found for $plugin_name"
    return 1
}

plug() {
    emulate -L zsh
    setopt local_options null_glob

    local plugin="$1"
    local git_ref="$2"
    local plugin_name plugin_dir plugin_path
    local data_home="${XDG_DATA_HOME:-$HOME/.local/share}"

    if [[ -z "$plugin" ]]; then
        print -ru2 "plug: missing plugin name"
        return 1
    fi

    if [[ "$plugin" == /* || "$plugin" == ./* || "$plugin" == ../* ]]; then
        plugin_path="${plugin:A}"

        if [[ -f "$plugin_path" ]]; then
            source "$plugin_path"
            return 0
        fi

        if [[ ! -d "$plugin_path" ]]; then
            print -ru2 "plug: local plugin not found: $plugin"
            return 1
        fi

        plugin_dir="$plugin_path"
        plugin_name="${plugin_dir:t}"
    else
        plugin_name="${plugin:t}"

        local candidate
        local -a candidates=(
            "$PLUG_HOME/$plugin_name"
            "$data_home/zap/plugins/$plugin_name"
            "/usr/share/$plugin_name"
            "/usr/share/zsh/plugins/$plugin_name"
            "/usr/local/share/$plugin_name"
        )

        for candidate in "${candidates[@]}"; do
            if [[ -d "$candidate" ]]; then
                plugin_dir="$candidate"
                break
            fi
        done

        if [[ -z "$plugin_dir" ]]; then
            if ! command -v git > /dev/null 2>&1; then
                print -ru2 "plug: git is required to install $plugin"
                return 1
            fi

            mkdir -p "$PLUG_HOME" || return
            plugin_dir="$PLUG_HOME/$plugin_name"

            local git_prefix="${PLUG_GIT_PREFIX:-https://github.com/}"
            local -a clone_args=(clone --depth 1)
            [[ -n "$git_ref" ]] && clone_args+=(--branch "$git_ref")

            print -ru2 "plug: installing $plugin_name"
            if ! git "${clone_args[@]}" "${git_prefix}${plugin}.git" "$plugin_dir" > /dev/null 2>&1; then
                print -ru2 "plug: failed to clone $plugin"
                return 1
            fi
        elif [[ -n "$git_ref" && -d "$plugin_dir/.git" ]]; then
            git -C "$plugin_dir" checkout "$git_ref" > /dev/null 2>&1 || {
                print -ru2 "plug: failed to checkout $git_ref for $plugin_name"
                return 1
            }
        fi
    fi

    _plug_source_entrypoint "$plugin_dir" "$plugin_name"
}

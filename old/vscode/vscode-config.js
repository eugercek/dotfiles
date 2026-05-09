{
    // ============================================================
    // Workbench
    // ============================================================
    "workbench.startupEditor": "none",
    "workbench.activityBar.location": "bottom",
    "workbench.sideBar.location": "left",
    "workbench.editor.useModal": "off",
    "workbench.editor.showTabs": "multiple",
    // "workbench.editor.showTabIndex": true,
    "workbench.editor.swipeToNavigate": true,
    "workbench.editor.editorActionsLocation": "titleBar",
    "workbench.layoutControl.enabled": false,
    "workbench.browser.showInTitleBar": true,
    "workbench.browser.openLocalhostLinks": true,
    "workbench.preferredDarkColorTheme": "Dark 2026",
    "workbench.panel.defaultLocation": "bottom",

    // ============================================================
    // Window
    // ============================================================
    "window.autoDetectColorScheme": true,
    "window.titleBarStyle": "native",
    "window.customTitleBarVisibility": "never",
    "window.commandCenter": false,
    "window.density.editorTabHeight": "compact",

    // ============================================================
    // Editor
    // ============================================================
    "editor.fontFamily": "JetBrainsMono Nerd Font Mono, Menlo, monospace",
    "editor.fontSize": 15,
    "editor.lineNumbers": "off",
    "editor.minimap.enabled": false,
    "editor.accessibilitySupport": "off",
    "editor.smoothScrolling": true,
    "editor.stickyScroll.enabled": true,
    "editor.bracketPairColorization.enabled": true,
    "editor.renderWhitespace": "trailing",
    "editor.linkedEditing": true,
    "editor.formatOnSave": true, // Very cool
    "editor.cursorSmoothCaretAnimation": "off", // Can access via C-b if needed
    "editor.scrollbar.horizontalScrollbarSize": 10,
    "editor.scrollbar.verticalScrollbarSize": 10,
    "breadcrumbs.enabled": false, // disable the input bar at the top

    // ============================================================
    // Diff Editor
    // ============================================================
    "diffEditor.hideUnchangedRegions.enabled": true,
    "diffEditor.experimental.useTrueInlineView": true,

    // ============================================================
    // Files
    // ============================================================
    "files.autoSave": "onFocusChange",
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.exclude": {
        "**/.git": true,
        "**/node_modules": true,
        "**/__pycache__": true,
        "**/.DS_Store": true
    },

    // ============================================================
    // Terminal
    // ============================================================
    "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono",
    "terminal.integrated.fontSize": 14,
    "terminal.integrated.smoothScrolling": true,
    "terminal.integrated.enableImages": true,
    "terminal.integrated.gpuAcceleration": "on",
    "terminal.integrated.enableMultiLinePasteWarning": "never",
    "terminal.integrated.initialHint": false,
    "terminal.integrated.profiles.osx": {
        "tmux-shell": {
            "path": "tmux",
            "args": ["new-session", "-A", "-s", "vscode:${workspaceFolderBasename}"]
        }
    },
    "terminal.integrated.defaultProfile.osx": "tmux-shell",
    "terminal.integrated.cursorStyle": "line",

    // ============================================================
    // SCM / Git
    // ============================================================
    "scm.repositories.selectionMode": "single",
    "scm.repositories.explorer": true,
    "git.openRepositoryInParentFolders": "never",
    "git.verboseCommit": true,
    "git.blame.editorDecoration.disableHover": true,
    "git.blame.ignoreWhitespace": true,

    // ============================================================
    // Misc
    // ============================================================
    "task.notifyWindowOnTaskCompletion": 30000,
    "chat.disableAIFeatures": true,
    "telemetry.telemetryLevel": "off",
    "update.showReleaseNotes": true,

    // ============================================================
    // Language overrides
    // ============================================================
    "[jsonc]": {
        "editor.formatOnSave": false
    },

    // ============================================================
    // Extensions (global)
    // ============================================================
    "extensions.ignoreRecommendations": true,
    "extensions.experimental.affinity": {
        "asvetliakov.vscode-neovim": 1
    },

    // ============================================================
    // Neovim (embedded via vscode-neovim) — all leader bindings live in init.lua
    // ============================================================
    "vscode-neovim.neovimExecutablePaths.darwin": "/opt/homebrew/bin/nvim",
    "vscode-neovim.compositeKeys": {
        "jk": { "command": "vscode-neovim.escape" }
    },

    // ============================================================
    // Claude Code
    // ============================================================
    "claudeCode.enableNewConversationShortcut": true,
    "claudeCode.useTerminal": true,
    "claudeCode.preferredLocation": "panel",

    // ============================================================
    // Custom UI Style (frameless window + status bar tweaks)
    // ============================================================
    // "custom-ui-style.electron": {
    //     "frame": false
    // },
    // "custom-ui-style.stylesheet": {
    //     "#status\\.scm\\.0 .statusbar-item-label": "font-size: 14px !important; font-weight: bold !important; color: #2aa198 !important; letter-spacing: 0.5px !important;",
    // },

    // ============================================================
    // Scratchpads
    // ============================================================
    "scratchpads.defaultFiletype": "md",
    "scratchpads.showInExplorer": true,

    // ============================================================
    // Obsidian
    // ============================================================
    "obsidian-md-vsc.defaultVault": "~/Desktop/Obsidian\\ Vault",

    // ============================================================
    // C/C++
    // ============================================================
    "C_Cpp.default.compilerPath": "/opt/homebrew/bin/gcc-15",

    // ============================================================
    // Terminal Notification
    // ============================================================
    "terminalNotification.showVsCodeNotification": false,

    // ============================================================
    // Project Manager
    // ============================================================
    "projectManager.git.baseFolders": [
      "/Users/umut/Desktop/work",
      "/Users/umut/Desktop/personal",
      "/Users/umut/Desktop/dotfiles",
      "/Users/umut/Desktop/Obsidian Vault",
    ],
    "projectManager.sortList": "Recent",
    "diffEditor.experimental.showMoves": true,
    "diffEditor.hideUnchangedRegions.contextLineCount": 1,
    "diffEditor.hideUnchangedRegions.revealLineCount": 5,
    "diffEditor.renderGutterMenu": false,
    "diffEditor.codeLens": true,
    "git.repositoryScanMaxDepth": 2,
    "git.autoRepositoryDetection": "subFolders",
    "scm.alwaysShowRepositories": true,
    "todohighlight.include": [

        "**/*.js",
        "**/*.jsx",
        "**/*.ts",
        "**/*.tsx",
        "**/*.html",
        "**/*.php",
        "**/*.css",
        "**/*.scss",
        "**/*.md"
    ],
    // Manual
}


This configuration is useful for Macbook users who prefer to use fullscreen applications while no external monitors are attached, and use windowed applications with multiple screens. This configuration also provides hotkeys that allow you to  move both windowed and fullscreen applications between screens as well as a hotkey for maximizing application windows to fit screen size.
 
### Dashboard

The dashboard allows you to toggle settings and run automation tasks. Activate the dashboard using  `Command` + `Shift` + `\`.

### Fullscreen Mode

Enabling **Fullscreen Mode** via Dashboard  will automatically trigger fullscreen when applications are launched. 

Once enabled, all active application windows will be fullscreened. Applications will be returned to windowed mode when Fullscreen Mode is disabled.

#### Multiple Displays

Fullscreen Mode is automatically disabled when multiple displays are detected and re-enabled when displays are disconnected.

### Window Manipulation

Windows and fullscreen applications can be moved between screens using hotkeys `Command` + `Option` + `Shift` + `Left` and `Right`. 

A window can be maximized to fit the full size of the screen by pressing  `Command` + `Option` + `Shift` + `Up`. Pressing `Command` + `Option` + `Shift` + `Down` will return a window to its previous size.

### App Launcher

The dashboard provides a *Launch Apps* button to launch applications whose names are specified in the `launchapps.apps` JSON object inside of `~/.hammerspoon/config/settings.json`.



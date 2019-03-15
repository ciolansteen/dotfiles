import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated")

  // Input
  //
  // Add input bindings here:
  //
  oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

  // CTRL-T to open sidebar (NerdTree like behaviour)
  oni.input.unbind("<s-c-b>") // default sidebar toggle keybinding
  oni.input.unbind("<c-t>") // unbind default Search Symbols
  oni.input.bind("<c-t>", "sidebar.toggle") // NerdTree line sidebar toggle
  oni.input.bind("<a-/>", "language.symbols.workspace") // sane shortcut to search symbols
    //
  // Or remove the default bindings here by uncommenting the below line:
  //
  // oni.input.unbind("<c-p>")
}

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated")
}

export const configuration = {
  //add custom config here, such as
  "oni.useDefaultConfig": true,
  //"oni.bookmarks": ["~/Documents"],
  "oni.loadInitVim": true,
  "editor.fontSize": "16px",
  "editor.fontFamily": "Hack",

  // UI customizations
  "ui.colorscheme": "gruvbox",
  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",
  "tabs.height": "2em",
  "explorer.persistOnNeovimExit": true
}

# Third-Party Asset Inventory

## Purpose

Track installed Asset Library packages separately from assets that are actually wired into gameplay, prototypes, or UI.

This document is an inventory only. It does not connect SFX, particles, input prompt icons, or license UI to the game.

## Application Policy

- Installed assets and actively used assets are separate states.
- Assets that are not connected to scenes, scripts, or UI are marked as `not wired yet`.
- CC0 or otherwise permissive assets still need their source, install path, and license evidence recorded.
- Any third-party asset included in a distributable build should be represented in a credits / license screen or bundled license file.
- `Simple License` is a candidate tool for a future license / credits display, but it is not connected in this pass.
- SFX, particle, and input prompt application should happen in separate implementation tasks.
- Do not delete, move, or stage installed Asset Library files as part of this documentation-only inventory pass.

## Inventory Table

| Asset | Source | Installed Path | License | License Evidence | Intended Use | Current Use | Commit Status | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Kenney Interface Sounds | Asset Library name: `Kenney Interface Sounds`; license text identifies `Interface Sounds (1.0)` by Kenney | Source install: `godot/addons/kenney_interface_sounds/`; selected copies: `godot/assets/audio/third_party/kenney/interface/` | Creative Commons Zero, CC0 | Source: `godot/addons/kenney_interface_sounds/LICENSE.txt`; copied evidence: `godot/assets/audio/third_party/kenney/LICENSES/kenney_interface_sounds_LICENSE.txt` | Interaction panel open/close, button hover/click, Phone UI click, Outlet UI click, Result continue | Selected prototype SFX wired: `prototype_open.wav`, `prototype_cancel.wav`, `hacking_hit.wav`, `hacking_damage.wav`, `hacking_success.wav`, `hacking_fail.wav` | Selected copied files and copied license are commit targets; original addon folder remains local installed / not committed | Similar intended UI-SFX role to `Kenney UI Audio`; possible functional overlap, but no duplicate folder was removed. |
| Kenney UI Audio | Asset Library name: `Kenney UI Audio`; license text identifies `UI SFX Set` by Kenney Vleugels | Source install: `godot/addons/kenney_ui_audio/`; selected copies: `godot/assets/audio/third_party/kenney/ui/` | Creative Commons Zero, CC0 | Source: `godot/addons/kenney_ui_audio/LICENSE.txt`; copied evidence: `godot/assets/audio/third_party/kenney/LICENSES/kenney_ui_audio_LICENSE.txt` | Prototype Hub selection, menu confirm/cancel, UI transition, warning/notification | Selected prototype UI SFX wired: `ui_select.wav`, `ui_confirm.wav` | Selected copied files and copied license are commit targets; original addon folder remains local installed / not committed | Similar intended UI-SFX role to `Kenney Interface Sounds`; only a small subset is copied for prototype use. |
| Kenney Prototype Textures | Asset Library name: `Kenney Prototype Textures`; license text identifies `Prototype Textures 1.0` by Kenney | `godot/addons/kenney_prototype_textures/` | Creative Commons Zero, CC0 | `godot/addons/kenney_prototype_textures/LICENSE.txt` | HackingActionPrototype arena readability, hazard tile placeholder, scan zone placeholder, wall/floor blockout texture | not wired yet | Installed locally; not staged in this docs-only pass | Keep as prototype-only visual material unless a later task deliberately applies it. |
| Kenney Particle Pack | Asset Library name: `Kenney Particle Pack`; license text identifies `Particle Pack (1.1)` by Kenney Vleugels | `godot/addons/kenney_particle_pack/` | Creative Commons Zero, CC0 | `godot/addons/kenney_particle_pack/LICENSE.txt` | Hacking hit FX, Trace/hazard feedback, NODE-17 pulse, device LED/glow, power warning spark | not wired yet | Installed locally; not staged in this docs-only pass | Particle use should stay separate from gameplay logic and be applied in a visual-feedback pass. |
| Kenney Input Prompts | Asset Library name: `Kenney Input Prompts`; license text identifies `Input Prompts (1.1)` by Kenney | Source install: `godot/addons/kenney_input_prompts/`; selected copies: `godot/assets/ui/third_party/kenney/input_prompts/` | Creative Commons Zero, CC0 | Source: `godot/LICENSE.txt`; copied evidence: `godot/assets/ui/third_party/kenney/LICENSES/kenney_input_prompts_LICENSE.txt` | `[E]`, `[D]`, `[R]`, `[B]`, WASD/arrow key UI icons, Prototype Hub controls, Quarterview prompt UI, Hacking prototype control guide | Selected prompt icons wired into PrototypeHub, QuarterviewRoomPrototype, and HackingActionPrototype prototype UI | Selected copied `.png` files, selected `.png.import` files, helper script, and copied license are commit targets; original addon folder remains local installed / not committed | License file was installed at `godot/LICENSE.txt` rather than inside the addon folder. Only selected `Keyboard & Mouse/Default` prompt PNGs are copied for prototype use. |
| Simple License | Asset Library / plugin name: `Simple License`; README identifies files under `./addons/simplelicense/*` | `godot/addons/simplelicense/`; supporting license data under `godot/licenses/` | CC0-1.0 | `godot/addons/simplelicense/LICENSE.txt`, `godot/addons/simplelicense/README.txt`, `godot/licenses/license_links/SimpleLicense.tres` | License / credits display candidate, third-party license viewer candidate | not wired yet | Installed locally; not staged in this docs-only pass | `godot/licenses/` and `godot/licenses/license_links/SimpleLicense.tres` appear to be support/example license data for the plugin, not a second UI integration. Not removed in this pass. |

## Duplicate And Overlap Notes

- `Kenney Interface Sounds` and `Kenney UI Audio` both provide UI-oriented click, switch, select, confirmation, and transition sounds. Treat them as overlapping libraries and pick a limited subset before wiring any sound into the project.
- `Simple License` appears once as a plugin under `godot/addons/simplelicense/`, with additional license-link data under `godot/licenses/`. This is support data, not an active in-game license screen.
- `Kenney Input Prompts` has no `LICENSE.txt` inside `godot/addons/kenney_input_prompts/`; its license evidence currently sits at `godot/LICENSE.txt`.

## Current Commit Policy

- Prototype SFX work commits only selected copied `.wav` files under `godot/assets/audio/third_party/kenney/`, their generated selected `.wav.import` files if Godot creates them, copied license evidence, prototype-only SFX helper/script changes, and minimal docs.
- Prototype input prompt work commits only selected copied `.png` files under `godot/assets/ui/third_party/kenney/input_prompts/`, their generated selected `.png.import` files if Godot creates them, copied license evidence, prototype-only prompt helper/script changes, and minimal docs.
- Installed external asset folders, their broad source-side `.import` files, `.uid` files, and `godot/LICENSE.txt` remain uncommitted until a later asset-application or vendor-assets decision.
- Existing unrelated local changes, including `godot/scripts/Apartment.gd`, are not part of this work.

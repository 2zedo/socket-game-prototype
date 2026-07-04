# Characters Reference

## Role

This is the current reference for character identity and visual / story constraints.

## Yui

Yui is the player character.

Current identity:

- lower-grid resident
- information worker / hacker
- organized, practical, and careful
- living under resource pressure
- emotionally drawn to the outside world, especially sea / horizon / open spaces

Room personality:

- Her room is tidy despite poverty.
- She does not collect useless luxury clutter.
- She maintains devices carefully because replacement is difficult.
- Her longing for freedom appears through restrained motifs: sea poster, horizon image, blue light, small shell-like object, travel / beach scraps.

Visual direction:

- Current temporary quarterview sprite exists under `godot/assets/art/quarterview/character/yui/`.
- In quarterview room images, Yui should be about `118-132px` high on a `1920x1080` canvas.
- Proportion target is about `2.5-3 heads`.
- Avoid chubby / squat / short-stubby proportions.
- The character is the scale anchor for the room and objects.

Implementation:

- Current top-view Main uses existing player flow.
- QuarterviewMain uses `QuarterviewPlayer.gd` with temporary sprite support and fallback placeholder.
- Collision / pathfinding / interaction scale should not be blindly tied to visual sprite scale.

## NAVI

NAVI is Yui's personal AI / proxy avatar candidate.

Current role:

- supports hacking entry concept
- can be described as the proxy that enters the target system while Yui prepares in the room
- appears in Hacking Entry candidate text

Current boundary:

- No persistent NAVI dialogue system.
- No final avatar sprite.
- No actual Hacking scene transition.
- No story flag integration.

## Anonymous Client

The first job sender is intentionally anonymous.

Current resource:

- `maintenance_17_fragment.tres`

Current UI:

- Phone job tab shows the sender as `익명 의뢰`.

Boundary:

- No faction identity or branching story has been implemented.

## Mika

Mika is currently an offscreen Phone / DM contact cue for Act 1.

Current role:

- reinforces that Phone is part of Yui's everyday life, not a fixed room object
- can be implied through Phone screen / charging spot / message notification direction
- should not become wall text, a large room label, or a physical room object

Boundary:

- No Mika scene, dialogue system, friendship system, save-load state, or production PhoneUI integration is wired yet.

## Character Implementation Files

| Purpose | Path |
| --- | --- |
| Quarterview player script | `godot/scripts/quarterview/QuarterviewPlayer.gd` |
| Quarterview temporary idle sheet | `godot/assets/art/quarterview/character/yui/yui_qv_idle_4dir.png` |
| Quarterview temporary walk sheet | `godot/assets/art/quarterview/character/yui/yui_qv_walk_4dir.png` |
| Current Main player script | `godot/scripts/Player.gd` |

## Character Non-Goals

- Do not regenerate Yui sprite unless explicitly requested.
- Do not connect NAVI to HackingActionPrototype without an explicit task.
- Do not treat room background concept characters as final player sprite.

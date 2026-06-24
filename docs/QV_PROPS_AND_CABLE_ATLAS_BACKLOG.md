# QV Props And Cable Atlas Backlog

## Purpose

This document records why `qv_props_atlas.png` and `qv_cable_atlas.png` are deferred backlog work.

These atlases can improve the lived-in feeling and power-management readability of Yui's quarterview room, but they are not required to validate the core room shell, Yui sprite, furniture, appliance, work-device, FX, or sandbox interaction pipelines.

This document does not add PNG assets, does not create region mapping JSON / CSV / `.tres`, and does not wire props or cable visuals into `QuarterviewRoomShellPrototype`, `QuarterviewGameplaySandbox`, Main, or DAY 1.

## Current Priority

Current quarterview visual pipeline priority:

```text
1. room shell layers
2. Yui quarterview spritesheet
3. furniture atlas
4. appliances atlas
5. work devices atlas
6. fx atlas
7. props atlas / cable atlas
```

Props and cable atlases are visual-detail layers, not blockers for the quarterview gameplay sandbox. They should not delay room shell, Yui sprite, furniture, appliance, work device, or FX pipeline validation.

## `qv_props_atlas.png`

`qv_props_atlas.png` is a future atlas candidate for small props, lived-in detail, and non-core decoration.

Candidate items:

```text
mug
small_notebook
loose_paper
small_tool
food_pack
folded_clothes
small_bag
maintenance_part
small_plant_extra_candidate
sticky_note
small_container
spare_part_box
personal_item_candidate
```

Props help the room feel inhabited, but they are not core MVP gameplay. They should stay subordinate to interactable objects, device readability, movement space, and prompt clarity.

## `qv_cable_atlas.png`

`qv_cable_atlas.png` is a future atlas candidate for cable, plug, adapter, and wire-management visuals.

Candidate items:

```text
cable_segment_straight
cable_segment_curve
cable_segment_corner
cable_coil
plug_1slot
plug_2slot
adapter_block
charger_cable
power_strip_body_candidate
outlet_socket_candidate
cable_tie
loose_wire
wall_cable_run
```

Cable atlas visuals do not own Outlet UI behavior, connected / active state calculation, or power drain. Those remain owned by `SurvivalState` or a future power-system controller. Cable atlas work is visual representation only.

## Deferred Reasoning

Props and cable atlases are intentionally deferred because:

- props add lived-in detail but do not create core interaction
- cables are visually complex and can easily drift away from future power / outlet rules if created too early
- room shell, player, furniture, appliances, and work devices should stabilize first
- cable paths depend on object positions and outlet / power UI policy
- core gameplay stability and interaction flow are higher priority
- props / cables are better handled during later polish and readability passes

## Future Paths

Future atlas filenames:

```text
qv_props_atlas.png
qv_cable_atlas.png
```

Expected future Godot paths:

```text
res://assets/rooms/quarterview/atlases/qv_props_atlas.png
res://assets/rooms/quarterview/atlases/qv_cable_atlas.png
```

Source / reference candidates:

```text
res://assets/rooms/quarterview/atlases/source/
res://assets/rooms/quarterview/atlases/reference/
```

Do not create these folders or PNG files during this backlog documentation pass.

## Atlas Split Criteria

### `qv_props_atlas.png` Includes

- small lived-in props
- non-core decoration
- paper / notebook / mug / small tools
- food packaging
- small personal items
- support props that do not damage room readability

### `qv_props_atlas.png` Excludes

- bed / desk / chair / shelf / cabinet / rug furniture
- fridge / microwave / aircon / fluorescent light / UPS appliances
- laptop / phone / NODE-17 / speaker / signal booster work devices
- cable / plug / outlet / adapter bodies
- room shell floor / wall / window / foreground
- FX / glow / signal wave
- UI icons
- player sprite

### `qv_cable_atlas.png` Includes

- cable segments
- plugs
- adapters
- charging cable
- cable coils
- wall cable runs
- power strip body candidate
- outlet / socket visual candidate

### `qv_cable_atlas.png` Excludes

- actual power state logic
- Outlet UI
- connected / active calculation
- `DeviceDefinition` values
- laptop / phone / communication device bodies
- appliance bodies
- furniture bodies
- room shell
- FX spark / glow
- UI icons
- player sprite

Other atlas / layer candidates:

```text
qv_furniture_atlas.png
qv_appliances_atlas.png
qv_work_devices_atlas.png
qv_fx_atlas.png
qv_room_static_lighting_overlay.png
qv_room_foreground_occluders.png
```

## Props Design Criteria

- Yui's room is a small lower-grid one-room apartment, but she earns some money as a hacker / information worker, so it should not look like a filthy dump.
- Props should add restrained lived-in detail.
- Props must not be more visually prominent than interactable objects.
- Plant use should stay at one small plant candidate at most.
- Speaker is not a prop; it is an `audio_hacking_device`.
- Props should use lower size, color, and contrast than core objects.
- Props should not include icon-like or text-like details that can be mistaken for UI or interaction prompts.

## Cable Design Criteria

- Cables can reinforce the power-management fantasy, but too many cables make the screen noisy.
- Do not rush cable atlas work before the outlet / power UI policy is stable.
- Cables are visual information and must not be confused with connected / active state logic.
- Cables must not hide player walkable areas or interaction prompts.
- Cable paths should be planned after furniture and device placement stabilizes.
- Whether power strip / outlet / plug visuals belong in `qv_cable_atlas.png` or a separate power atlas is a later decision.
- Spark and glow effects belong to `qv_fx_atlas.png`.

## Future Mapping Field Candidates

This backlog document does not define a full region mapping schema. Later mapping work can start from these lightweight field candidates.

Props mapping candidates:

```text
prop_key
atlas_path
rect
anchor_type
default_z_index
category
visual_priority
notes
```

Cable mapping candidates:

```text
cable_key
atlas_path
rect
anchor_type
default_z_index
cable_type
connection_hint
visual_state
notes
```

Coordinates remain undefined until actual atlas PNG files exist.

## Z-Index Candidates

Layer candidates:

| Layer | z-index | Role |
| --- | ---: | --- |
| `FloorLayer` | `0` | floor visual |
| `FloorPropsLayer` | `20` | small floor props |
| `FurnitureLayer` | `30` | furniture bodies |
| `ApplianceLayer` | `34` | appliance bodies |
| `DeviceLayer` | `35` | work-device bodies |
| `CableLayer` | `36` | cable / plug visuals |
| `PlayerLayer` | `40` | player |
| `ObjectHighlightLayer` | `50` | highlights |
| `FxLayer` | `60` | localized FX |
| `ForegroundOccluderLayer` | `80` | foreground occluders |
| `StaticLightingOverlayLayer` | `90` | full-room lighting / shadow overlay |
| `InteractionPromptLayer` | `100` | prompts |
| `UILayer` | `1000` | UI |

Rules:

- floor props usually stay below the player
- props on a table / desk may need placement with furniture or device layers
- most cables stay below the player
- plug / spark / glow should stay separated between cable visuals and `qv_fx_atlas.png`
- interaction prompts must stay above props and cables

## Start Conditions

Props atlas work should start only when:

- room shell layers are stable
- furniture placement is stable
- work device and appliance placement is stable
- readability problems have been reviewed
- the room feels too empty or unlived-in

Cable atlas work should start only when:

- outlet / power UI policy is clearer
- device positions are stable
- power strip / outlet position is stable
- connected / active visual representation is actually needed
- cable visuals help the player understand power flow

Props / cable work should start only after core room composition and interaction flow are stable.

## Future Work Candidates

- `qv_props_atlas.png` region mapping detailed design
- `qv_cable_atlas.png` region mapping detailed design
- props candidate list pass
- cable / power visual policy pass
- power strip / outlet / plug atlas split decision
- props / cable prototype scene
- props / cable visibility toggle prototype
- decorative props placement test in `QuarterviewGameplaySandbox`
- Outlet / Power UI and cable visual sync review

## Non-Goals

- Do not add `qv_props_atlas.png` or `qv_cable_atlas.png`.
- Do not create mapping JSON / CSV / `.tres`.
- Do not create `AtlasTexture` or `Sprite2D` nodes.
- Do not place props or cables in any scene.
- Do not connect cables to Outlet UI, `SurvivalState`, Main, DAY 1, or power logic.
- Do not use props as interactable-object substitutes.

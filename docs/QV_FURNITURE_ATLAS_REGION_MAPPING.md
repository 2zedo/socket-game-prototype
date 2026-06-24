# QV Furniture Atlas Region Mapping

## Purpose

This document defines the future region mapping rules for `qv_furniture_atlas.png`.

It does not create or apply the atlas. It only fixes the naming, schema, category, pivot, z-index, and checklist rules that should be used when quarterview furniture art is produced.

The atlas is for furniture body visuals only. Device state sprites, appliances, room shell layers, UI icons, player sprites, FX, and cable visuals stay in separate atlas or layer categories.

## Atlas File

Future atlas file:

```text
res://assets/rooms/quarterview/atlases/qv_furniture_atlas.png
```

Source / reference candidate folders:

```text
res://assets/rooms/quarterview/atlases/source/
res://assets/rooms/quarterview/atlases/reference/
```

Basic file criteria:

- PNG
- RGBA / transparent background
- Same art direction as the quarterview room
- Furniture only
- No player sprite
- No UI labels or text
- No room shell wall / floor baked into furniture regions
- No device state sprites mixed into the furniture atlas

## Atlas And Mapping Roles

`qv_furniture_atlas.png` is the sprite atlas image.

The region mapping is metadata for coordinates, size, anchor, pivot, z-index hints, and object-key links. Actual coordinates are decided after the atlas is produced. This document defines the schema only.

`RoomObjectDefinition` owns object contract data such as:

- `key`
- `display_name`
- `zone`
- `role`
- `future_source`
- `visual_state`

The furniture atlas mapping says which visual region should be used for that object.

Examples:

- `object_key=bed`, `region_key=bed_base`
- `object_key=desk`, `region_key=desk_work`
- `object_key=plant_pot`, `region_key=plant_pot_small`

## Region Key Naming

Region keys use:

- `snake_case`
- lowercase
- object category + variation
- state / variant suffix only when useful
- stable names, not temporary numbering

Good examples:

- `bed_base`
- `bed_blanket`
- `desk_work`
- `chair_simple`
- `shelf_wall`
- `cabinet_small`
- `storage_box_stack`
- `rug_small`
- `plant_pot_small`
- `floor_mat_entry`

Bad examples:

- `sprite1`
- `item_001`
- `bed2_final_new`
- `tmp_chair`
- `image_05`
- `object_a`

Common suffix candidates:

- `_base`
- `_alt`
- `_small`
- `_large`
- `_front`
- `_side`
- `_shadow`
- `_damaged`

## Mapping Schema

Future mapping records should include the following fields. This task does not create JSON, CSV, `.tres`, `AtlasTexture`, or any other mapping resource.

| Field | Type | Purpose | Example |
| --- | --- | --- | --- |
| `region_key` | `String` | Stable atlas region key | `bed_base` |
| `atlas_path` | `String` | Atlas image path | `res://assets/rooms/quarterview/atlases/qv_furniture_atlas.png` |
| `rect_x` | `int` | Region x coordinate in atlas | `TBD` |
| `rect_y` | `int` | Region y coordinate in atlas | `TBD` |
| `rect_w` | `int` | Region width | `TBD` |
| `rect_h` | `int` | Region height | `TBD` |
| `pivot_x` | `float` | Visual pivot x inside region | `TBD` |
| `pivot_y` | `float` | Visual pivot y inside region | `TBD` |
| `foot_anchor_x` | `float` | Floor contact / placement anchor x | `TBD` |
| `foot_anchor_y` | `float` | Floor contact / placement anchor y | `TBD` |
| `default_z_index` | `int` | Default visual layer hint | `30` |
| `object_key` | `String` | Related `RoomObjectDefinition.key` | `bed` |
| `category` | `String` | Furniture category | `sleeping` |
| `collision_hint` | `String` | Non-authoritative collision hint | `static_blocker` |
| `occlusion_hint` | `String` | Player overlap / occlusion note | `behind_player` |
| `notes` | `String` | Free notes | `candidate only` |

Example candidate record:

```text
region_key: bed_base
atlas_path: res://assets/rooms/quarterview/atlases/qv_furniture_atlas.png
rect: TBD
pivot: bottom-center
foot_anchor: bottom-center
default_z_index: 30
object_key: bed
category: sleeping
collision_hint: static_blocker
occlusion_hint: behind_player
notes: manual_end_day object candidate
```

## Future Mapping Format Candidates

### Resource

Candidate paths:

```text
godot/scripts/resources/AtlasRegionDefinition.gd
godot/resources/rooms/quarterview/atlases/qv_furniture_atlas_regions.tres
```

Pros:

- Inspector editing
- Type safety
- Consistent with existing Resource pipeline

Cons:

- Bulk editing many regions can be tedious

### JSON

Candidate path:

```text
godot/assets/rooms/quarterview/atlases/qv_furniture_atlas_regions.json
```

Pros:

- Easy to export from external tools
- Easy to bulk edit
- Works well for generated atlas metadata

Cons:

- Lower type safety
- Requires parser / validation code

### CSV

Candidate path:

```text
godot/assets/rooms/quarterview/atlases/qv_furniture_atlas_regions.csv
```

Pros:

- Spreadsheet editing is easy

Cons:

- Weak nested metadata support
- Weak type expression

Current recommendation:

- Keep this document as the source of criteria for now.
- Leave Resource / JSON / CSV open until the actual atlas exists.
- Decide the mapping format after region count and editing workflow are clear.

## Furniture Categories

Category candidates:

- `sleeping`
- `work`
- `storage`
- `seating`
- `decoration`
- `floor_decor`
- `wall_furniture`
- `utility_furniture`

Examples:

| Region Key | Category |
| --- | --- |
| `bed_base` | `sleeping` |
| `desk_work` | `work` |
| `chair_simple` | `seating` |
| `shelf_wall` | `wall_furniture` |
| `cabinet_small` | `storage` |
| `storage_box_stack` | `storage` |
| `rug_small` | `floor_decor` |
| `plant_pot_small` | `decoration` |

Plant use should stay restrained. The adopted room direction allows at most one small plant pot so the room does not become decorative or upscale.

## Furniture / Device / Appliance Split

### `qv_furniture_atlas.png` Includes

- bed
- desk
- chair
- shelf
- cabinet
- storage box
- rug
- small plant pot
- non-interactive furniture body

### `qv_furniture_atlas.png` Excludes

- laptop
- phone
- charger
- outlet / power strip
- NODE-17
- communication device
- speaker / audio hacking device
- signal booster
- UPS if treated as device
- fridge
- microwave
- aircon
- fluorescent light
- room shell floor / wall / window / foreground
- UI icons
- player sprite

Other atlas candidates:

- `qv_work_devices_atlas.png`
- `qv_appliances_atlas.png`
- `qv_props_atlas.png`
- `qv_cable_atlas.png`
- `qv_fx_atlas.png`

Speaker is not furniture. It is a hacking / audio-analysis device candidate and should stay in a work-device atlas.

Fridge, microwave, and air conditioner are living appliances and should stay in an appliances atlas.

## Pivot And Anchor Criteria

Default placement rules:

- Sprite visual pivot should use bottom-center or object-footprint center.
- Room placement should use a floor contact point.
- Wall-mounted objects need a separate wall anchor note.
- Tall furniture should prefer bottom-center.
- Rug / floor mat should explicitly record center or top-left placement.
- Pivot can differ from collision.

Recommended anchors:

| Object Type | Anchor |
| --- | --- |
| floor furniture | `foot_anchor = bottom-center` |
| wall furniture | `wall_anchor = top-left` or `center`, recorded in notes |
| rug / floor mat | `placement_anchor = center` or `top-left`, recorded in notes |

Pivot / anchor is a visual placement rule.

Collision and interaction range are managed separately through `Area2D`, `RoomObjectDefinition`, or `RoomSceneContract`.

## Z-Index And Y-Sort Criteria

Layer candidate values:

| Layer | Z |
| --- | --- |
| `FloorLayer` | `0` |
| `WindowCityViewLayer` | `8` |
| `BackWallLayer` | `10` |
| `SideWallLayer` | `15` |
| `FurnitureLayer` | `30` |
| `DeviceLayer` | `35` |
| `PlayerLayer` | `40` |
| `ObjectHighlightLayer` | `50` |
| `ForegroundOccluderLayer` | `80` |
| `StaticLightingOverlayLayer` | `90` |
| `InteractionPromptLayer` | `100` |
| `UILayer` | `1000` |

Furniture default:

```text
default_z_index = 30
```

Exceptions:

- Wall-mounted shelf: above back wall; furniture layer or wall-furniture layer candidate.
- Rug / floor mat: above floor and below player; z-index `5` to `20` candidate.
- Desk / bed / chair: can overlap with the player; if fixed z-index is not enough, evaluate Y-sort.

Y-sort candidates:

- If object / player overlap becomes dense, use `YSort` or y-position-based z-index.
- MVP can start with fixed z-index plus foreground occluder.
- If player position needs tuning, keep visual anchor and collision separate.

## Example Mapping Table

Coordinates are intentionally `TBD`. Do not treat this table as final atlas data.

| region_key | object_key | category | rect | pivot | z | notes |
| --- | --- | --- | --- | --- | --- | --- |
| `bed_base` | `bed` | `sleeping` | `TBD` | `bottom-center` | `30` | `manual_end_day` object candidate |
| `desk_work` | `desk` | `work` | `TBD` | `bottom-center` | `30` | laptop / device placed separately |
| `chair_simple` | `chair` | `seating` | `TBD` | `bottom-center` | `30` | decorative or future sit action candidate |
| `shelf_wall` | `shelf` | `wall_furniture` | `TBD` | `wall-anchor` | `30` | wall-mounted |
| `cabinet_small` | `cabinet` | `storage` | `TBD` | `bottom-center` | `30` | storage candidate |
| `rug_small` | `rug` | `floor_decor` | `TBD` | `center` | `10` | below player |
| `plant_pot_small` | `plant_pot` | `decoration` | `TBD` | `bottom-center` | `30` | only one small plant |

## Pre-Application Checklist

- [ ] Atlas PNG has transparent background.
- [ ] Regions do not overlap.
- [ ] Each region rect fully contains the sprite.
- [ ] Hair, legs, furniture edges, and shadows are not cropped.
- [ ] `region_key` uses `snake_case`.
- [ ] `object_key` relationship is documented.
- [ ] Pivot / foot anchor is clear.
- [ ] Furniture, device, and appliance categories are not mixed.
- [ ] Baked shadow is not too strong.
- [ ] Lighting overlay does not conflict with baked values.
- [ ] Room shell perspective matches.
- [ ] Player scale matches.

## Future Application Order

1. Prepare final `qv_furniture_atlas.png` asset.
2. Add PNG to the atlas path.
3. Write region key and rect list.
4. Decide mapping format: Resource, JSON, or CSV.
5. Create `AtlasTexture` or region loader prototype.
6. Create `QuarterviewFurnitureAtlasPrototype`.
7. Check every region visually.
8. Review links to `RoomObjectDefinition.object_key`.
9. Test furniture placement in `QuarterviewGameplaySandbox`.
10. Check readability with occluders, lighting, and player scale.

## Non-Goals

This document does not:

- Add actual PNG assets
- Generate or resize images
- Create `AtlasTexture`
- Create JSON / CSV / `.tres` mapping files
- Modify scenes
- Modify `RoomObjectDefinition` values
- Wire atlas art into `QuarterviewGameplaySandbox`
- Change Main / DAY 1

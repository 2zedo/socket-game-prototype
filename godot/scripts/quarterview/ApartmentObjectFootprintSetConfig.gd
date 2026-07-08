extends Resource
class_name ApartmentObjectFootprintSetConfig

# Groups shell-only object footprint placeholders so the apartment layout can be
# tuned from a Resource instead of editing the candidate scene script.
@export_multiline var note := ""
@export var objects: Array[ApartmentObjectFootprintConfig] = []

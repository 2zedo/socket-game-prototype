# 쿼터뷰 Room / 기존 Apartment 기능 대응표

## 목적

이 문서는 현재 탑뷰 Apartment 기능을 장기적으로 쿼터뷰 Room으로 옮길 때 누락을 막기 위한 대응표다.

현재 작업은 구현 이식이 아니다. 기존 `Main.tscn`, `Apartment.gd`, `SurvivalState.gd`, Phone / Outlet / Result / Test Mode 흐름은 유지하고, 쿼터뷰 prototype placeholder와 기존 기능의 대응 관계만 정리한다.

## 대응표

| 기존 기능 | 현재 구현 기준 | 쿼터뷰 대응 후보 | 비고 |
| --- | --- | --- | --- |
| Bed / End Day | 기존 bed interactable | `bed` placeholder / `manual_end_day` | 수동 하루 종료 |
| Laptop | laptop interactable | `desk`, `laptop` placeholder / `laptop_job` | 장기적으로 해킹 미션 진입점 |
| Power Strip / Outlet | outlet interactable | `power` placeholder / `power_management` | 기존 Outlet UI 유지 후보 |
| Communication Device | communication interactable | `communication_device` placeholder / `communication` | 외부 신호 / 의뢰 |
| Phone / Charger | charger interactable + Phone UI | `phone` placeholder / `phone_charge` | Phone UI는 `Tab` 유지 |
| Light / Lamp | 현재 1-slot 장치 | 장기적으로 형광등 기본 설비 검토 | 구현 결정 필요 |
| Fan | 현재 Fan 장치 | 장기적으로 AC 교체 검토 | 구현 결정 필요 |
| NODE-17 | 미구현 | `node_17` placeholder / `mystery_device` | 메인 미스터리 장치 |
| Fridge | 미구현 | `fridge` placeholder / `living_appliance` | 생활 유지 장치 |
| Microwave | 미구현 | `microwave` placeholder / `living_appliance` | 순간 소비 장치 |
| AC | 미구현 | `air_conditioner` placeholder / `living_appliance` | Fan 대체 후보 |

## 유지해야 할 시스템

쿼터뷰 Room으로 옮기더라도 아래 시스템은 유지 대상으로 본다.

- `SurvivalState`
- `DeviceDefinition` Resource
- Phone UI
- Outlet UI
- Result UI
- 02:00 자동 종료
- Test Mode
- connected / active 분리

## 아직 구현하지 말 것

아래 항목은 현재 대응표에서만 정리하고, 이번 단계에서는 구현하지 않는다.

- Main scene 교체
- 쿼터뷰 Room 본 이식
- Phone / Outlet / Result 연결
- NODE-17 구현
- Fridge / Microwave / AC 구현
- Fan 제거
- Light 정책 변경
- 해킹 액션 연결

## Prototype Placeholder 기준

`QuarterviewRoomPrototype.gd`의 `PLACEHOLDERS` 배열은 쿼터뷰 이식 검토용 임시 데이터다.

- `key`: 이식 시 기능 연결의 기준이 될 내부 이름
- `label`: prototype 화면에 표시되는 짧은 이름
- `zone`: 방 안 구역 구분
- `role`: 기존 Apartment 기능 또는 장기 기능과의 대응 의도
- `position`, `size`: prototype 배치 조정값
- `blocks`: 임시 충돌 여부
- `interactable`: `E` placeholder 상호작용 여부

이 데이터는 실제 DAY 1 장치 Resource를 대체하지 않는다. 장치 밸런스, 전력 소비, 슬롯 규칙은 계속 기존 Godot 구현과 Resource를 기준으로 관리한다.

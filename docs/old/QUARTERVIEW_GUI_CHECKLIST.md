# Quarterview GUI Checklist

이 문서는 `QuarterviewMain`을 Godot GUI에서 직접 확인하기 위한 클릭 순서 체크리스트다.
현재 범위는 QuarterviewMain-only candidate이며, `SurvivalState`, `DayResultPanel`, save-load, story flag는 연결하지 않는다.

## Start

- [ ] `res://scenes/QuarterviewMain.tscn`을 실행한다.
- [ ] 임시 room background가 보인다.
- [ ] prototype HUD가 화면을 크게 가리지 않고 읽힌다.
- [ ] HUD에 DAY / 시간 / 전력 / 허기 / 컨디션 / 메모가 보인다.
- [ ] 기본 화면에서 `P`를 누르면 Phone screen candidate가 열린다.
- [ ] 기본 화면에서 `R`을 눌러도 QuarterviewMain이 재시작되지 않는다.

## Room Movement

- [ ] 방 바닥을 클릭하면 player placeholder가 이동한다.
- [ ] 큰 오브젝트나 벽 근처에서 이동이 멈추거나 우회한다.
- [ ] 빠르게 여러 번 클릭해도 멈추거나 에러가 나지 않는다.
- [ ] 오브젝트를 클릭하면 player가 접근한다.
- [ ] 접근 후 candidate panel이 열린다.
- [ ] candidate panel의 빈 영역을 클릭하면 panel이 닫힌다.
- [ ] panel을 닫은 뒤 다시 방 클릭 이동이 가능하다.

## Desk / Laptop

- [ ] Desk 또는 Laptop을 클릭한다.
- [ ] Desk의 `사용하기`를 누르면 Desk close-up이 열린다.
- [ ] 수락된 의뢰가 없는 상태에서 Laptop을 사용하면 Phone 의뢰 확인 안내만 남는다.
- [ ] Laptop / Communication Device / NODE-17 / Signal Booster / Speaker / Job Memo를 선택할 수 있다.
- [ ] 선택 / 사용 / 설명은 status log만 남긴다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 close-up이 닫힌다.
- [ ] 닫은 뒤 room movement와 object click이 복구된다.

## Hacking Entry Candidate

- [ ] `P`로 Phone을 열고 의뢰 탭에서 `maintenance_17_fragment`를 수락한다.
- [ ] Laptop을 직접 사용하면 `NAVI 프록시 준비` overlay가 열린다.
- [ ] Desk close-up에서 Laptop 또는 Job Memo를 선택하고 `사용하기`를 누르면 같은 overlay가 열린다.
- [ ] overlay에 현재 의뢰 / 의뢰자 / 보수 / 위험도 / 침투 준비 후보 상태가 보인다.
- [ ] `프록시 점검`은 HUD 메모와 status log만 갱신한다.
- [ ] `침투 시작 후보`는 “해킹 씬은 아직 연결되지 않았습니다” status만 남긴다.
- [ ] 실제 Hacking scene, Grid Credit, save-load, story flag는 호출되지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 overlay가 닫힌다.
- [ ] 닫은 뒤 room movement와 object click이 복구된다.

## Power

- [ ] Power object를 클릭한다.
- [ ] `사용하기`를 누르면 Power close-up이 열린다.
- [ ] module을 선택하고 `모듈 확인`을 누른다.
- [ ] module을 클릭만 하면 선택만 되고, board로 이동하거나 snap되지 않는다.
- [ ] module을 일정 거리 이상 드래그해야 ghost가 나타나며 움직인다.
- [ ] inventory module을 드래그할 때 ScrollContainer 안의 원래 항목이 버벅이거나 같이 끌려 나오지 않는다.
- [ ] 모듈을 보드에 배치하면 왼쪽 Module Inventory에서 사라진다.
- [ ] 남은 inventory 모듈은 위에서부터 빈칸 없이 다시 정렬된다.
- [ ] inventory가 길어져도 panel 밖으로 튀어나오지 않고 스크롤로 확인할 수 있다.
- [ ] L-shape module을 잡은 칸 기준으로 빈 공간에 예상대로 배치할 수 있다.
- [ ] 모듈 A와 B를 인접 배치한 뒤 A를 다시 선택한다.
- [ ] A를 `R` 또는 우클릭으로 회전해도 자기 자신의 기존 cells와 충돌하지 않는다.
- [ ] A의 회전 후 cells가 B와 실제로 겹치는 경우만 invalid 처리된다.
- [ ] invalid rotation은 회전 전 상태로 복귀한다.
- [ ] invalid drop은 drag 시작 전 위치 / 배치 상태 / 회전 / inventory 순서로 복구된다.
- [ ] 오른쪽 detail panel의 `보관함으로` 버튼으로 selected placed module을 inventory로 되돌릴 수 있다.
- [ ] Delete / Backspace로도 selected placed module을 inventory로 되돌릴 수 있다.
- [ ] 배치된 모듈을 inventory panel 위로 드롭하면 inventory 맨 아래에 추가된다.
- [ ] HUD의 전력 상태 / 메모가 mock 값으로 갱신된다.
- [ ] 실제 OutletMode나 SurvivalState는 열리지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 close-up이 닫힌다.

## Phone

- [ ] 책상 위 Phone 위치에 마우스를 올려도 `[클릭] Phone` hover prompt가 뜨지 않는다.
- [ ] Phone object를 직접 클릭해서 candidate panel이 열리지 않는다.
- [ ] 기본 room 상태에서 `P`를 누르면 Phone screen candidate가 열린다.
- [ ] Battery / Signal / Messages / Charge Port를 선택할 수 있다.
- [ ] 의뢰 탭에서 `maintenance_17_fragment` 후보와 수락 상태를 확인할 수 있다.
- [ ] 선택 / 확인 시 HUD 메모나 정보 수집 후보가 mock 값으로 갱신된다.
- [ ] 실제 PhoneUI나 SurvivalState phone battery는 열리지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 overlay가 닫힌다.

## Bed / Day Result

- [ ] Bed object를 클릭한다.
- [ ] `사용하기`를 누르면 Bed rest overlay가 열린다.
- [ ] `잠깐 쉰다`를 선택하면 HUD 컨디션 / 시간 / 메모가 mock 값으로 갱신된다.
- [ ] `몸 상태를 확인한다`를 선택하면 status log와 HUD 메모가 갱신된다.
- [ ] `오늘을 마무리한다`를 선택하고 `선택`을 누르면 Day Result candidate가 열린다.
- [ ] Day Result가 현재 mock 전력 / 허기 / 컨디션 / 정보 / 메모를 반영한다.
- [ ] `다음 날 후보`를 누르면 DAY가 증가하고 mock 상태가 일부 기본값으로 리셋된다.
- [ ] 실제 DayResultPanel, SurvivalState day advance, save-load는 호출되지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 overlay가 닫힌다.

## Food / Kitchen

- [ ] Fridge object를 클릭한다.
- [ ] `사용하기`를 누르면 Food / Kitchen overlay가 열린다.
- [ ] 보관 식량 확인 / 간단히 먹을 것 찾기 / 냉장고 상태 확인을 선택할 수 있다.
- [ ] 음식 관련 선택 시 HUD 허기 / 전력 / 메모가 mock 값으로 갱신된다.
- [ ] Microwave object도 같은 방식으로 확인한다.
- [ ] 합성 식품 데우기 / 조리 상태 확인 / 오늘 먹을 것 생각하기를 선택할 수 있다.
- [ ] 실제 hunger system, inventory, SurvivalState는 변경되지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 overlay가 닫힌다.

## Door

- [ ] Door object를 클릭한다.
- [ ] `사용하기`를 누르면 Door overlay가 열린다.
- [ ] 문 밖 상황 확인 / 복도 소리 듣기 / 외출 준비 생각하기를 선택할 수 있다.
- [ ] 선택 / 설명은 status log만 남긴다.
- [ ] 실제 scene transition, outside map, story flag, save-load는 호출되지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 overlay가 닫힌다.

## Input Lock

- [ ] candidate panel이 열린 동안 방 클릭 이동이 발생하지 않는다.
- [ ] close-up / overlay가 열린 동안 방 클릭 이동이 발생하지 않는다.
- [ ] overlay 안쪽 버튼을 클릭해도 빈 영역 닫기로 오동작하지 않는다.
- [ ] overlay를 닫으면 room movement와 object click이 복구된다.

## Debug / Tuning

- [ ] `D`를 누르면 debug overlay가 켜진다.
- [ ] debug ON에서 object label, click area, footprint, path guide를 읽을 수 있다.
- [ ] debug ON에서 arrow key 이동이 가능하다.
- [ ] `D`를 반복해도 player 위치나 camera가 밀리지 않는다.
- [ ] `F3`으로 footprint tuning mode가 켜진다.
- [ ] `[` / `]`로 selected object가 바뀐다.
- [ ] `C`를 누르면 layout snippet이 출력된다.
- [ ] debug ON 상태에서만 `Shift+R`이 개발용 restart로 동작한다.
- [ ] debug OFF로 돌아가면 기본 화면이 과하게 지저분하지 않다.

## Pass / Needs Fix

Pass:

- [ ] 기본 배경, HUD, click movement, object interaction 흐름이 한 번에 이해된다.
- [ ] 모든 candidate overlay가 열리고 닫힌다.
- [ ] HUD mock 반응이 production 상태처럼 오해되지 않는다.
- [ ] room input lock / restore가 안정적이다.
- [ ] protected Main / DAY1 기능이 전혀 호출되지 않는다.

Needs Fix:

- [ ] HUD나 overlay가 배경 / player / panel을 과하게 가린다.
- [ ] 빠른 클릭이나 반복 object click 중 멈춤 / 에러가 발생한다.
- [ ] overlay 중 room movement가 발생한다.
- [ ] 닫은 뒤 room movement가 복구되지 않는다.
- [ ] production PhoneUI / OutletMode / DayResultPanel / SurvivalState가 열리거나 값이 바뀐다.

# Quarterview GUI Checklist

이 문서는 `QuarterviewMain`을 Godot GUI에서 직접 확인하기 위한 클릭 순서 체크리스트다.
현재 범위는 QuarterviewMain-only candidate이며, `SurvivalState`, `DayResultPanel`, save-load, story flag는 연결하지 않는다.

## Start

- [ ] `res://scenes/QuarterviewMain.tscn`을 실행한다.
- [ ] 임시 room background가 보인다.
- [ ] prototype HUD가 화면을 크게 가리지 않고 읽힌다.
- [ ] HUD에 DAY / 시간 / 전력 / 허기 / 컨디션 / 메모가 보인다.
- [ ] `R`을 누르면 QuarterviewMain이 재시작된다.

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
- [ ] `사용하기`를 누르면 Desk close-up이 열린다.
- [ ] Laptop / Communication Device / NODE-17 / Signal Booster / Speaker / Job Memo를 선택할 수 있다.
- [ ] 선택 / 사용 / 설명은 status log만 남긴다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 close-up이 닫힌다.
- [ ] 닫은 뒤 room movement와 object click이 복구된다.

## Power

- [ ] Power object를 클릭한다.
- [ ] `사용하기`를 누르면 Power close-up이 열린다.
- [ ] module을 선택하고 `모듈 확인`을 누른다.
- [ ] HUD의 전력 상태 / 메모가 mock 값으로 갱신된다.
- [ ] 실제 OutletMode나 SurvivalState는 열리지 않는다.
- [ ] ESC / 닫기 버튼 / 빈 영역 클릭으로 close-up이 닫힌다.

## Phone

- [ ] Phone object를 클릭한다.
- [ ] `사용하기`를 누르면 Phone overlay가 열린다.
- [ ] Battery / Signal / Messages / Charge Port를 선택할 수 있다.
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

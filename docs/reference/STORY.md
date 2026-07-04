# Story Reference

## Role

This is the current reference for story structure, Act direction, job candidates, and mystery hooks.

## Core Story Fantasy

Yui survives in a lower-grid room by taking information jobs, managing limited power, and entering hacking spaces through NAVI proxy systems. The room is both a shelter and a workstation.

The story should make the player feel:

- daily survival pressure
- technical competence
- constrained choices
- curiosity about forbidden logs
- longing for outside freedom

## Act 1 Direction

Act 1 starts small:

- Yui is in her room.
- A first anonymous job arrives.
- The job points to a closed maintenance log fragment.
- Public network upload is forbidden.
- NAVI proxy preparation is required before actual hacking.

The goal is not to immediately open the full hacking mode. The room should first teach:

1. Check current state.
2. Read / accept a job.
3. Prepare at Desk / Laptop / NAVI entry.
4. Manage power / food / rest candidates.
5. End day / review result candidate.

## First Job Candidate

Current resource:

- `godot/resources/rooms/quarterview/jobs/maintenance_17_fragment.tres`

Current fields:

- key: `maintenance_17_fragment`
- title: `maintenance_17_fragment 회수`
- sender: `익명 의뢰`
- reward: `45 GC`
- risk: `낮음`
- related object: `laptop`

Story text:

- 폐쇄 유지보수 로그 조각을 회수하십시오.
- 공공망 업로드 금지.
- NAVI 프록시 준비 필요.

Current implementation boundary:

- Phone job tab can show and accept the job in QuarterviewMain mock state.
- HUD / Day Result / Desk / Laptop reflect the active job candidate.
- Hacking Entry candidate overlay shows NAVI proxy preparation.
- Real Hacking scene transition, Grid Credit reward, save-load, story flags, and production result are not wired.

## NAVI

NAVI is Yui's personal AI / proxy avatar candidate for hacking mode.

Story role:

- It is not just UI decoration.
- It is the bridge between real-room Yui and hacking-space infiltration.
- It allows the narrative to say Yui prepares in the room while NAVI enters the target system.

Current boundary:

- NAVI is referenced in text and Hacking Entry candidate.
- No persistent character system, dialogue system, or hacking avatar link is wired yet.

## NODE-17

NODE-17 is a long-term mystery device / story hook.

Current role:

- object key candidate: `node17`
- role: `mystery_device`
- may connect to forbidden logs, external signals, story flags, Laptop, Communication Device, and Hacking later.

Current boundary:

- It exists as room object data / candidate hotspot.
- No story flag or mission logic is wired.

## Story Non-Goals For Current QuarterviewMain

- No real mission completion.
- No Grid Credit payout.
- No save-load.
- No story flags.
- No branching story state.
- No production dialogue system.
- No real HackingActionPrototype scene transition.

# Alarm Acknowledgement Workflow

## Operator Goal

The operator must be able to clear an active alarm from the Active alarms count from the alarm page without hunting for a separate hidden control.

## Initial State

On first launch:

- Active alarms: `1`
- Acknowledged: `1`
- Auto-clear: `1`
- Selected alarm: `ALM-1042`
- `ALM-1042` status: `Active`

The active queue ticket uses red text and red border emphasis.

## Path 1: Active Alarms KPI

1. Operator taps `Active alarms`.
2. Dashboard opens `Alarm Acknowledge Page`.
3. Page shows selected alarm `ALM-1042`.
4. Operator taps `Acknowledge Alarm`.
5. Status changes to `Acknowledged`.
6. Active alarms drops from `1` to `0`.
7. Button changes to `Acknowledgement Recorded`.
8. Note confirms the alarm was removed from Active alarms.

## Path 2: Alarm Queue Ticket

1. Operator opens `Alarm Center`.
2. Operator taps the `ALM-1042` queue ticket.
3. Since the ticket is active, the click acknowledges it immediately.
4. The queue keeps `ALM-1042` selected for review.
5. The ticket text changes from `Demand peak | Active` to `Demand peak | Acknowledged`.
6. Active alarms drops to `0`.
7. Red active text is removed because the event is no longer active.

## Non-Active Ticket Behavior

Clicking an already acknowledged or auto-clear ticket only selects that event. It does not change the active count.

## State Transition

```text
ALM-1042 Active
  |
  | Acknowledge button or active queue click
  v
ALM-1042 Acknowledged
  |
  v
Active alarms KPI = 0
```

## UI Contract

| Element | Expected Behavior |
| --- | --- |
| Active alarms KPI | Opens the acknowledge page. |
| Acknowledge Alarm button | Acknowledges selected active alarm. |
| Alarm Details button | Returns to Alarm Center. |
| Active queue ticket | Acknowledges and selects the alarm. |
| Acknowledged queue ticket | Selects only. |
| Active red text | Appears only when `status === "Active"`. |

## Regression Checks

- Active alarm count starts at `1`.
- `ALM-1042` starts as active.
- Clicking `ALM-1042` in the queue changes its status to acknowledged.
- Active alarm count changes to `0`.
- The selected acknowledged ticket does not retain active red text.
- The acknowledgement page still records acknowledgement if reached from the KPI.

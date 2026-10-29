# Interaction

How players act on the world.

## Selecting a target

Players click (or tap) the thing they want to act on. Today that means a
tree. Clicking a tree:

1. walks the player to the nearest reachable tile next to it, going around
   obstacles,
2. then starts gathering from it.

If no path exists, nothing happens. Using the movement keys while walking
cancels the walk.

## Reach

A player can act on a tile when it is one of the 8 tiles around the tile
holding the centre of the player. Diagonal counts.

## Cancelling

A running action stops when the player moves, clicks somewhere else or
starts another action.

## Feedback

While gathering, a progress bar over the player shows the current action.
When an action can't start or stops on its own, the player sees why (see
[skills.md](skills.md#the-action-loop)).

## Open questions

- Interacting with other things: chests, NPCs, placing blocks.
- Keyboard-only interaction (act on the faced tile) for accessibility.
- Touch controls for mobile.

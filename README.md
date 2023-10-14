# Lex' Mouse Gestures

Assign keystrokes or subroutines to vague mouse movements (gestures). Gestures are triggered by holding the gesture key (default is the right mouse button), drawing a sequence of "strokes," then releasing the gesture key. By default, a stroke can be up, down, left or right. The default settings make it fairly tolerant; i.e. it isn't necessary to know where the mouse pointer is, what it is pointing at or how far you are moving it.

Originally released in 2007 on the original AutoHotkey forums:
https://www.autohotkey.com/board/topic/23596-lex-mouse-gestures/page-1

Requires AutoHotkey v1.0.48.05 or v1.1.x.

## Features

  - Allows an arbitrary number of directions ("zones"), though 4 is the most practical and efficient.
  - Allows any number of "strokes" in a gesture (between pressing and releasing the gesture key).
  - Gestures either execute a label or send keystrokes.
  - Wheel gestures (gesture key + wheel up/down.)
  - Various options controlling gesture recognition. See Gestures.ahk for a description of each option.
  - Custom enabled/disabled tray icons.
  - Win + Gesture key enables/disables gestures, and indicates the current status by playing a sound from Wurt Simplicity.
  - Note that it ignores the length of each stroke (excluding `m_LowThreshold` and `m_HighThreshold`), so two consecutive strokes cannot be in the same zone. For instance, `Gesture_L_L` is not valid, since it would be recognized as `Gesture_L`.
  - Draw visible gestures on-screen by setting the `m_PenWidth` option. To define the colour, set `m_PenColor` to a RRGGBB colour code.

## Script Structure

  - `Gestures.ahk` contains the "gesture engine."
  - `Gestures_Default.ahk` contains the default scripted gestures.
  - `Gestures_User.ahk` should be created by the user to contain user-defined gestures, option overrides or any unrelated scripts.

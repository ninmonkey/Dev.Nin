- [Selection of some Emoji](#selection-of-some-emoji)
  - [conversion snippet](#conversion-snippet)
  - [Searches](#searches)
  - [List : No Names](#list--no-names)
  - [List: Named](#list-named)

# Selection of some Emoji

## conversion snippet

```powershell
# Get a unique
$source.EnumerateRunes().count | Label 'Codepoints'
$source.EnumerateRunes() | sort -Unique | Measure | % Count | Label 'Unique Codepoints'

$strip_NL = $source -split '\r?\n' -join ''
$UniqueCodepointList = $strip_NL.EnumerateRunes() | sort Value | Join-String -sep "`n"

$UniqueCodepointList.EnumerateRunes() | Measure Value | % Count | Label 'Unique Codepoint List'
$UniqueCodepointList

# $source.EnumerateRunes() | sort -Unique | Measure | % Count |
Label 'Grapheme Count' '?'
$sourceWithGrapheme = $source
```

## Searches

<https://www.compart.com/en/unicode/search?q=dash#characters>
<https://www.compart.com/en/unicode/search?q=button#characters>
<https://www.compart.com/en/unicode/search?q=run#characters>
<https://emojipedia.org/activity/>
<https://emojipedia.org/objects/>
<https://emojipedia.org/travel-places/>
<https://emojipedia.org/search/?q=button>

## List : No Names

⌨️
⌨️
🎚️
🎧
🐁
🐛🐜🦋🦗🐸 🐝 🦎 🔬
🔇
🔈
🔉🔊
🖥️📁💾⚙️🛠️🕹️⌨️🔍💻🖱️📰 
🤖
🦟 🦂 🐌 🕷️ 🕸️
😕
😬
🚨🆕
🆗⇢

## List: Named

☑️ Check Box with Check
☑️ Check Box with Check
☠️ Skull and Crossbones
⚙️ Gear
⚙️ Gear
✅ Check Mark Butto
✅ Check Mark Button
✔️ Check Mark
✖️ Multiply
❌ Cross Mark
❗ Exclamation Mark
➕ Plus
➖ Minus
➗ Divide
⭕ Hollow Red Circle
🍂 Fallen Leaf
🎥 Movie Camera
🎲 Game Die
🏡 House with Garden
🐇 Rabbit
🐌 Snail
🐍 Snake
🐝 Honeybee
🐞 Lady Beetle
🐰 Rabbit Face
👌 OK Hand
👍 Thumbs Up
👮 Police Officer
👺 Goblin
👻 Ghost
👻 Ghost
👽 Alien
👽 Alien
👾 Alien Monster
👾 Alien Monster
👾 Alien Monster
💀 Skull
💩 Pile of Poo
📹 Video Camera
📺 Television
🔘 Radio Button
🔜 Soon Arrow
🔜 Soon Arrow
🔠 Input Latin Uppercase
🔥 Fire
🔬 Microscope
🕷️ Spider
🕸️ Spider Web
🕹️ Joystick
🖥️ Desktop Computer
🖥️ Desktop Computer
🖲️ Trackball
🗳️ Ballot Box with Ballot
🦂 Scorpion
🦎 Lizard
🦟 Mosquito
🦠 Microbe
🦨 Skunk
🦾 Mechanical Arm
🦿 Mechanical Leg
🧩 Puzzle Piece
🧫 Petri Dish
🧲 Magnet
🧸 Teddy Bear
🧸 Teddy Bear
🪀 Yo-Yo
😐 Neutral Face
😬 Grimacing Face
😱 Face Screaming in Fear
🙆 Person Gesturing OK
🚑 Ambulance
🚒 Fire Engine
🚓 Police Car
🚔 Oncoming Police Car
🚨 Police Car Light
🚩 Triangular Flag
🅰️ A Button (Blood Type)
🅱️ B Button (Blood Type)
🆑 CL Button
🆑 CL Button
🆒 Cool Button
🆒 Cool Button
🆒 Cool Button
🆓 Free Button
ℹ️ Information
🆔 U+1F194
🆔 U+1F194
🆕 New Button
🆗 OK Button
🆗 OK Button
🈂️ Japanese “Service Charge” Button
🪰 Fly
🪱 Worm
🪲 Beetle
🪳 Cockroach

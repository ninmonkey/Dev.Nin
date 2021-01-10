- [Selection of some Emoji](#selection-of-some-emoji)
  - [conversion snippet](#conversion-snippet)
  - [Searches](#searches)
  - [List: Code or Programming](#list-code-or-programming)
  - [List: Delimiters](#list-delimiters)
    - [Short list](#short-list)
    - [More](#more)
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

## List: Code or Programming

## List: Delimiters 

⇢
⁞

### Short list

⇢
⁞
💻 Laptop
⚙️ Gear
📋 Clipboard
🕹️ Joystick
⌨️ Keyboard
🖊️ Pen
🖥️ Desktop Computer
🖱️ Computer Mouse
🧰 Toolbox
🎚️
🐛
🐜
💡 Light Bulb

### More

💻 Laptop
⚙️ Gear
📋 Clipboard
📎 Paperclip
📓 Notebook
📚 Books
📝 Memo
📹 Video Camera
🔑 Key
🔘 Radio Button
🔥 Fire

🔬 Microscope
🕷️ Spider
🕹️ Joystick
⌨️ Keyboard
🖊️ Pen
🖋️ Fountain Pen
🖌️ Paintbrush
🖍️ Crayon
🖥️ Desktop Computer
🖱️ Computer Mouse
🗓️ Spiral Calendar
🧰 Toolbox
😐 Neutral Face
😬 Grimacing Face
😱 Face Screaming in Fear
🚩 Triangular Flag
👩‍🔬 N get name Science / lab grapheme ?
🆔 U+1F194
🆕 New Button
🆗 OK Button
💡 Light Bulb
🔧 Wrench
🐌
🕷️
🖥️📁💾⚙️🛠️🕹️⌨️🔍💻🖱️📰
✔️


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
🆗
📝 Memo
📓 Notebook
⇢
🎨 Artist Palette
📚 Books
📅 Calendar
📋 Clipboard

## List: Named

☑️ Check Box with Check
☑️ Check Box with Check
☠️ Skull and Crossbones
⚙️ Gear
⚙️ Gear
✅ Check Mark Butto
✅ Check Mark Button
✍️ Writing Hand
✍️ Writing Hand
✍🏻 Writing Hand: Light Skin Tone
✍🏼 Writing Hand: Medium-Light Skin Tone
✍🏽 Writing Hand: Medium Skin Tone
✍🏾 Writing Hand: Medium-Dark Skin Tone
✍🏿 Writing Hand: Dark Skin Tone
✏️ Pencil
✒️ Black Nib
✔️ Check Mark
✖️ Multiply
❌ Cross Mark
❗ Exclamation Mark
➕ Plus
➖ Minus
➗ Divide
⭕ Hollow Red Circle
🍂 Fallen Leaf
🎒 Backpack
🎥 Movie Camera
🎨 Artist Palette
🎲 Game Die

🎹 Musical Keyboard
⌨️ Keyboard
🎹 Musical Keyboard
🏡 House with Garden
🏫 School
🐇 Rabbit
🐌 Snail
🐍 Snake
🐝 Honeybee
🐞 Lady Beetle
🐰 Rabbit Face
👌 OK Hand
👌 OK Hand
👍 Thumbs Up
👨‍🎨 Man Artist
👨‍💻 Man Technologist
👨‍💻 Man Technologist
👩‍🎨 Woman Artist
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
💻 Laptop
📅 Calendar
📆 Tear-Off Calendar
📋 Clipboard
📎 Paperclip
📏 Straight Ruler
📐 Triangular Ruler
📒 Ledger
📓 Notebook
📔 Notebook with Decorative Cover
📚 Books
📝 Memo
📝 Memo
📝 Memo
📹 Video Camera
📺 Television
🔑 Key
🔑 Key
🔘 Radio Button
🔜 Soon Arrow
🔜 Soon Arrow
🔠 Input Latin Uppercase
🔥 Fire
🔬 Microscope
🕷️ Spider
🕸️ Spider Web
🕹️ Joystick
🕹️ Joystick
🕹️ Joystick
🖇️ Linked Paperclips
🖊️ Pen
🖋️ Fountain Pen
🖌️ Paintbrush
🖍️ Crayon
🖥️ Desktop Computer
🖥️ Desktop Computer
🖥️ Desktop Computer
🖥️ Desktop Computer
🖱️ Computer Mouse
🖲️ Trackball
🖲️ Trackball
🗒️ Spiral Notepad
🗓️ Spiral Calendar
🗳️ Ballot Box with Ballot
🤏 Pinching Hand
🦂 Scorpion
🦎 Lizard
🦟 Mosquito
🦠 Microbe
🦨 Skunk
🦾 Mechanical Arm
🦿 Mechanical Leg
🧩 Puzzle Piece
🧫 Petri Dish
🧰 Toolbox
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
🚗 Automobile
🔋 Battery
🚲 Bicycle
🧱 Brick
🏗️ Building Construction
⛓️ Chains
🔐 Locked with Key
🗜️ Clamp
🖥️ Desktop Computer
💡 Light Bulb
🏭 Factory
🔨 Hammer
🔑 Key
🔗 Link
🖇️ Linked Paperclips
🔒 Locked
🔏 Locked with Pen
🧲 Magnet
👨‍🏭 Man Factory Worker
🔩 Nut and Bolt
🔓 Unlocked
📎 Paperclip
🏎️ Racing Car
🏍️ Motorcycle
🤖 Robot
🪛 Screwdriver
🧰 Toolbox
📐 Triangular Ruler
👩‍🏭 Woman Factory Worker
🔧 Wrench

⏩ Fast-Forward Button
⏪ Fast Reverse Button
🎥 Movie Camera
📀 DVD
📷 Camera
📸 Camera with Flash
📹 Video Camera
📺 Television
📻 Radio
📽️ Film Projector

✔️
😓 Downcast Face with Sweat
    👍 Thumbs Up
    👍🏻 Thumbs Up: Light Skin Tone
    👍🏼 Thumbs Up: Medium-Light Skin Tone
    👍🏽 Thumbs Up: Medium Skin Tone
    👍🏾 Thumbs Up: Medium-Dark Skin Tone
    👍🏿 Thumbs Up: Dark Skin Tone

See also

    🤙 Call Me Hand
    👏 Clapping Hands
    🙆 Person Gesturing OK
    🔥 Fire
    👌 OK Hand
    🙌 Raising Hands
    🆗 OK Button
    👎 Thumbs Down
    ✌️ Victory Hand

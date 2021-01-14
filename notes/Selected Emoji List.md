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

🎨 Artist Palette
🖌️ Paintbrush

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
🍭
🦄
🎆
📚
🌈
🍊
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


🎨 Artist Palette

Emoji Meaning A palette used by an artist when painting, to store and mix paint colors. …
🖌️ Paintbrush

Emoji Meaning A thin, artist's paintbrush, as used to paint a picture. Often depicted with reddish paint on its pointed bristles.…
🖼️ Framed Picture

Emoji Meaning A framed picture of a painting or photograph, as displayed in a gallery or on a household wall. Vendors feature various…
🎠 Carousel Horse

Emoji Meaning A wooden painted horse, found on the carousel at a carnival. Faces to the left-of screen. A previous version of Windows…
😱 Face Screaming in Fear

Emoji Meaning A yellow face screaming in fear, depicted by wide, white eyes, a long, open mouth, hands pressed on cheeks, and a pale blue…
🐾 Paw P


🖊️ Pen

Emoji Meaning A blue or black ballpoint pen, as used for everyday writing. Depicted with its cap removed onto its end or as retractable…
🔏 Locked with Pen

Emoji Meaning A locked (closed) padlock with a fountain pen or nib positioned at various angles in front of it. Vendors implement the…
🖋️ Fountain Pen

Emoji Meaning A black fountain pen with a silver nib, as used for signing important documents. Often depicted with gold hardware.…
✒️ Black Nib

Emoji Meaning The silver nib of a fountain pen, which distributes ink onto a writing surface. Positioned at a 45° angle, with its tip at…
✍️ Writing Hand

Emoji Meaning A right hand holding a pen or pencil and writing. Shown with a blue pen on all platforms except Apple which has a black…
🔒 Locked

Emoji Meaning A locked (closed) padlock, as used to secure a latch or chain, or as an icon for a secure internet connection, private…
🖆 Pen Over Stamped Envelope

Emoji Meaning Pen Over Stamped Envelope was approved as part of Unicode…
🏴󠁴󠁷󠁰󠁥󠁮󠁿 Flag for Penghu (TW-PEN)

Emoji Meaning The Flag for Penghu (TW-PEN) emoji is a tag sequence combining 🏴 Black Flag, 󠁴 Tag Latin Small



🍭 Lollipop

Emoji Meaning A colorful swirl of hard candy on a stick, called a lollipop. Color varies widely by platform: Google…
🦄 Unicorn

Emoji Meaning The face of a unicorn, a mythical creature in the form of a white horse with a single, long horn on its forehead. Generally…
🎆 Fireworks

Emoji Meaning Firework emoji, showing a explosion of colored light in the night sky, used for any number of celebrations such as New…
📚 Books

Emoji Meaning A loose stack of three of more different-colored, hardcover books. Commonly used for various content concerning reading and…
🥢 Chopsticks

Emoji Meaning A pair of equal-length chopsticks, an eating utensil used throughout East Asia. Design and color vary widely by platform,…
🪁 Kite

Emoji Meaning A diamond-shaped kite with a tail. This emoji appears in various colors across platforms. …
🦠 Microbe

Emoji Meaning A microbe, as a bacterium grown in a 🧫 Petri Dish or observed under a 🔬 Microscope. Generally depicted as a squiggly,…
🌈 Rainbow

Emoji Meaning The colorful arc of a rainbow, as may appear after rain. Generally depicted as the left half of a full rainbow, showing six…
🧬 DNA

Emoji Meaning The double helix of DNA, the genetic blueprint for life. Color and orientation vary across platforms, but positioned at a…
💅 Nail Polish

Emoji Meaning Colored nail polish being applied to finger nails, often used to display an air of nonchalance or indifference. Shown…
⛱️ Umbrella on Ground

Emoji Meaning A large, open umbrella, as provides shade at a beach or patio. Generally depicted as a striped umbrella inserted into a…
🎋 Tanabata Tree

Emoji Meaning A Tanabata tree, a type of wish tree on which people hang wishes written on paper and other decorations during Tanabata, a…
🐰 Rabbit Face

Emoji Meaning A friendly, cartoon-styled face of a rabbit, looking straight ahead. Generally depicted as a gray and/or white rabbit face…
🛍️ Shopping Bags

Emoji Meaning Two colorful shopping bags, as contain consumer items bought at a department store. Depicted as gift bags in various bright…
🌺 Hibiscus

Emoji Meaning A pink hibiscus, a flower that grows in warm climates. Depicted as a single, deep-pink hibiscus flower with green leaves…
🍊 Tangerine

Emoji Meaning An orange-colored citrus fruit with a green leaf or leaves and stem. Officially depicting a tangerine, a type of mandarin…
🥎 Softball

Emoji Meaning A softball, which is differentiated from a baseball by size (it is larger, though hard to tell in emoji form) and color…
🪅 Piñata

Emoji Meaning A colorful decorated container that comes in many shapes, a piñata is filled with candy or toys. Hit to break open for…
🧥 Coat

Emoji Meaning A winter jacket, shown in a variety of colors and styles. …
🩲 Briefs

Emoji Meaning Underwear or swim briefs. The swimming variety are often called 'Speedos' after the br
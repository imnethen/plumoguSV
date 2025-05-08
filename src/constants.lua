DEFAULT_WIDGET_HEIGHT = 26            -- value determining the height of GUI widgets
DEFAULT_WIDGET_WIDTH = 160            -- value determining the width of GUI widgets
PADDING_WIDTH = 8                     -- value determining window and frame padding
RADIO_BUTTON_SPACING = 7.5            -- value determining spacing between radio buttons
SAMELINE_SPACING = 5                  -- value determining spacing between GUI items on the same row
ACTION_BUTTON_SIZE = { 255, 42 }      -- dimensions of the button that does important things
PLOT_GRAPH_SIZE = { 255, 100 }        -- dimensions of the plot graph for SVs and note motion
HALF_ACTION_BUTTON_SIZE = { 125, 42 } -- dimensions of a button that does kinda important things
SECONDARY_BUTTON_SIZE = { 48, 24 }    -- dimensions of a button that does less important things
TERTIARY_BUTTON_SIZE = { 21.5, 24 }   -- dimensions of a button that does much less important things
EXPORT_BUTTON_SIZE = { 40, 24 }       -- dimensions of the export menu settings button
BEEG_BUTTON_SIZE = { 255, 24 }        -- beeg button

------------------------------------------------------------------------------- Number restrictions

MIN_RGB_CYCLE_TIME = 0.1            -- minimum seconds for one complete RGB color cycle
MAX_RGB_CYCLE_TIME = 300            -- maximum seconds for one complete RGB color cycle
MAX_CURSOR_TRAIL_POINTS = 100       -- maximum number of points for cursor trail effects
MAX_SV_POINTS = 1000                -- maximum number of SV points allowed
MAX_ANIMATION_FRAMES = 999          -- maximum number of animation frames allowed
MAX_IMPORT_CHARACTER_LIMIT = 999999 -- maximum number of characters allowed for import text

CHINCHILLA_TYPES = { -- types of chinchilla SVs
    "Exponential",
    "Polynomial",
    "Circular",
    "Sine Power",
    "Arc Sine Power",
    "Inverse Power",
    "Peter Stock"
}
COLOR_THEMES = { -- available color themes for the plugin
    "Classic",
    "Strawberry",
    "Amethyst",
    "Tree",
    "Barbie",
    "Incognito",
    "Incognito + RGB",
    "Tobi's Glass",
    "Tobi's RGB Glass",
    "Glass",
    "Glass + RGB",
    "RGB Gamer Mode",
    "edom remag BGR",
    "BGR + otingocnI",
    "otingocnI"
}
COMBO_SV_TYPE = { -- options for overlapping combo SVs
    "Add",
    "Cross Multiply",
    "Remove",
    "Min",
    "Max",
    "SV Type 1 Only",
    "SV Type 2 Only"
}
CURSOR_TRAILS = { -- available cursor trail types
    "None",
    "Snake",
    "Dust",
    "Sparkle"
}
DISPLACE_SCALE_SPOTS = { -- places to scale SV sections by displacing
    "Start",
    "End"
}
EDIT_SV_TOOLS = { -- tools for editing SVs
    "Add Teleport",
    "Align Timing Lines",
    "bug fixing from <1.1.1",
    "Copy & Paste",
    "Displace Note",
    "Displace View",
    "Dynamic Scale",
    "Fix LN Ends",
    "Flicker",
    "Measure",
    "Merge",
    "Reverse Scroll",
    "Scale (Displace)",
    "Scale (Multiply)",
    "Swap Notes",
    "Vertical Shift"
}
EMOTICONS = { -- emoticons to visually clutter the plugin and confuse users
    "( - _ - )",
    "( e . e )",
    "( * o * )",
    "( h . m )",
    "( ~ _ ~ )",
    "( - . - )",
    "( C | D )",
    "( w . w )",
    "( ^ w ^ )",
    "( > . < )",
    "( + x + )",
    "( o _ 0 )",
    "[ m w m ]",
    "( v . ^ )",
    "( ^ o v )",
    "( ^ o v )",
    "( ; A ; )",
    "[ . _ . ]",
    "[ ' = ' ]",
}
FINAL_SV_TYPES = { -- options for the last SV placed at the tail end of all SVs
    "Normal",
    "Custom"
}
FLICKER_TYPES = { -- types of flickers
    "Normal",
    "Delayed"
}
NOTE_SKIN_TYPES = { -- types of note skins
    "Bar",
    "Circle"
    --,    "Arrow"
}
PLACE_TYPES = { -- general categories of SVs to place
    "Standard",
    "Special",
    "Still"
}
RANDOM_TYPES = { -- distribution types of random values
    "Normal",
    "Uniform"
}
SCALE_TYPES = { -- ways to scale SVs
    "Average SV",
    "Absolute Distance",
    "Relative Ratio"
}
SPECIAL_SVS = { -- types of special SVs
    "Stutter",
    "Teleport Stutter",
    "Splitscroll (Basic)",
    "Splitscroll (Advanced)",
    "Splitscroll (Adv v2)",
    "Penis",
    "Frames Setup"
}

STANDARD_SVS = { -- types of standard SVs
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla",
    "Combo"
}
STANDARD_SVS_NO_COMBO = { -- types of standard SVs (excluding combo)
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla"
}
STILL_TYPES = { -- types of still displacements
    "No",
    "Start",
    "End",
    "Auto",
    "Otua"
}
STUTTER_CONTROLS = { -- parts of a stutter SV to control
    "First SV",
    "Second SV"
}
STYLE_THEMES = { -- available style/appearance themes for the plugin
    "Rounded",
    "Boxed",
    "Rounded + Border",
    "Boxed + Border"
}
SV_BEHAVIORS = { -- behaviors of SVs
    "Slow down",
    "Speed up"
}
TAB_MENUS = { -- names of the tab menus
    "Info",
    "Select",
    "Create",
    "Edit",
    "Delete"
}
TRAIL_SHAPES = { -- shapes for cursor trails
    "Circles",
    "Triangles"
}
SELECT_TOOLS = {
    "Alternating",
    "By Snap",
    "Chord Size",
    "Note Type",
    "Bookmark",
}

BETA_IGNORE_NOTES_OUTSIDE_TG = false

STILL_BEHAVIOR_TYPES = {
    "Entire Region",
    "Per Note Group",
}
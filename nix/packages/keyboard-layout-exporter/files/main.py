#!/usr/bin/env python3

import subprocess, os, re, argparse
from PIL import Image, ImageDraw, ImageFont

KEY_W, KEY_H = 62, 62
GAP          = 5
PAD          = 30
CORNER       = 7
FONT_MAIN    = 14
FONT_SHIFT   = 11
FONT_BIND    = 9
FONT_LABEL   = 10
BLOCK_GAP    = 40

# Colors
BG            = (20,  22,  30)
KEY_DEFAULT   = (48,  51,  68)
KEY_BOUND     = (70,  35,  95)
KEY_STROKE    = (75,  80, 115)
KEY_BND_STR   = (160, 80, 220)
TEXT_MAIN     = (230, 235, 255)
TEXT_SHIFT    = (150, 158, 200)
TEXT_BIND     = (210, 160, 255)
TEXT_KEYLABEL = (90,  95, 130)

ROWS = [
    # Fn row + Numpad Top
    [("Esc",9,1.0), None, ("F1",67,1.0),("F2",68,1.0),("F3",69,1.0),("F4",70,1.0), None,
     ("F5",71,1.0),("F6",72,1.0),("F7",73,1.0),("F8",74,1.0), None,
     ("F9",75,1.0),("F10",76,1.0),("F11",95,1.0),("F12",96,1.0), "BLOCK",
     ("Prt",107,1.0),("Slk",78,1.0),("Pse",127,1.0)],

    # Number row + Numpad upper
    [("`",49,1.0),("1",10,1.0),("2",11,1.0),("3",12,1.0),("4",13,1.0),("5",14,1.0),
     ("6",15,1.0),("7",16,1.0),("8",17,1.0),("9",18,1.0),("0",19,1.0),("-",20,1.0),
     ("=",21,1.0),("Bksp",22,2.0), "BLOCK",
     ("Num",77,1.0),("/",106,1.0),("*",63,1.0),("-",82,1.0)],

    # QWERTY row + Numpad middle
    [("Tab",23,1.5),("Q",24,1.0),("W",25,1.0),("E",26,1.0),("R",27,1.0),("T",28,1.0),
     ("Y",29,1.0),("U",30,1.0),("I",31,1.0),("O",32,1.0),("P",33,1.0),("[",34,1.0),
     ("]",35,1.0),("\\",51,1.5), "BLOCK",
     ("kp7",79,1.0),("kp8",80,1.0),("kp9",81,1.0),("+",86,1.0)],

    # ASDF row + Numpad lower
    [("Caps",66,1.75),("A",38,1.0),("S",39,1.0),("D",40,1.0),("F",41,1.0),("G",42,1.0),
     ("H",43,1.0),("J",44,1.0),("K",45,1.0),("L",46,1.0),(";",47,1.0),("'",48,1.0),
     ("Enter",36,2.25), "BLOCK",
     ("kp4",83,1.0),("kp5",84,1.0),("kp6",85,1.0)],

    # ZXCV row + Numpad bottom
    [("Shift",50,2.25),("Z",52,1.0),("X",53,1.0),("C",54,1.0),("V",55,1.0),("B",56,1.0),
     ("N",57,1.0),("M",58,1.0),(",",59,1.0),(".",60,1.0),("/",61,1.0),("Shift",62,2.75), "BLOCK",
     ("kp1",87,1.0),("kp2",88,1.0),("kp3",89,1.0),("Ent",104,1.0)],

    # Space row + Numpad zero
    [("Ctrl",37,1.25),("Super",133,1.25),("Alt",64,1.25),("Space",65,6.25),
     ("AltGr",108,1.25),("Super",134,1.25),("Menu",135,1.25),("Ctrl",105,1.25), "BLOCK",
     ("kp0",90,2.05),(".",91,1.0)],
]

ROW_INDENT = [0, 0, 0, 0, 0, 0]

SYM_MAP = {
    "exclam":"!","at":"@","numbersign":"#","dollar":"$","percent":"%",
    "asciicircum":"^","ampersand":"&","asterisk":"*","parenleft":"(",
    "parenright":")","minus":"-","underscore":"_","equal":"=","plus":"+",
    "bracketleft":"[","bracketright":"]","braceleft":"{","braceright":"}",
    "backslash":"\\","bar":"|","semicolon":";","colon":":",
    "apostrophe":"'","quotedbl":'"',"grave":"`","asciitilde":"~",
    "comma":",","period":".","slash":"/","question":"?",
    "less":"<","greater":">","space":"SPC",
    "Return":"Enter","BackSpace":"Bksp","Tab":"Tab","Caps_Lock":"Caps",
    "Escape":"Esc","Delete":"Del","Insert":"Ins",
    "Home":"Home","End":"End","Prior":"PgUp","Next":"PgDn",
    "Left":"←","Right":"→","Up":"↑","Down":"↓",
    "Control_L":"Ctrl","Control_R":"Ctrl",
    "Shift_L":"Shift","Shift_R":"Shift",
    "Alt_L":"Alt","Alt_R":"Alt","Meta_L":"Meta","Meta_R":"Meta",
    "Super_L":"Super","Super_R":"Super","Hyper_L":"Hyper","Hyper_R":"Hyper",
    "Menu":"Menu","ISO_Level3_Shift":"AltGr","Multi_key":"Compose",
    "NoSymbol":"","VoidSymbol":"",
    "KP_0":"kp0","KP_1":"kp1","KP_Decimal":"kp.","KP_Enter":"kpEnt",
    "KP_Add":"kp+","KP_Subtract":"kp-","KP_Multiply":"kp*","KP_Divide":"kp/",
    "XF86AudioMute":"Mute","XF86AudioLowerVolume":"Vol-","XF86AudioRaiseVolume":"Vol+",
    "XF86MonBrightnessUp":"Bri+","XF86MonBrightnessDown":"Bri-",
    "XF86AudioPlay":"Play","XF86AudioStop":"Stop",
    "XF86AudioPrev":"Prev","XF86AudioNext":"Next","F20":"Ctrl+O",
}

def sym(s):
    if not s or s in ("NoSymbol", "VoidSymbol"):
        return ""
    if s in SYM_MAP:
        return SYM_MAP[s]
    if s.startswith("XF86"):
        return s[4:9]
    if s.startswith("KP_"):
        return "kp" + s[3:6]
    if len(s) == 1:
        return s
    return s[:7]

def get_xmodmap():
    """Return dict {keycode: [sym0, sym1, ...]} from live xmodmap -pke."""
    try:
        raw = subprocess.check_output(["xmodmap", "-pke"], text=True, stderr=subprocess.DEVNULL)
    except FileNotFoundError:
        print("[error] xmodmap not found — is it installed and are you in an X session?")
        return {}
    except subprocess.CalledProcessError as e:
        print(f"[error] xmodmap failed: {e}")
        return {}
    result = {}
    for line in raw.splitlines():
        m = re.match(r"keycode\s+(\d+)\s+=\s*(.*)", line)
        if m:
            kc   = int(m.group(1))
            syms = [s for s in m.group(2).split() if s]
            if syms:
                result[kc] = syms
    return result

def get_xbindkeys():
    """Return dict {keycode: command_string} from ~/.xbindkeysrc."""
    path = os.path.expanduser("~/.my-input-remappings/xbindkeys/global")
    if not os.path.exists(path):
        print(f"[info] {path} not found — skipping xbindkeys overlay.")
        return {}
    bindings = {}
    with open(path) as f:
        lines = f.read().splitlines()
    cmd = None
    for line in lines:
        stripped = line.strip()
        if not stripped:
            cmd = None
            continue
        if stripped.startswith("#"):
            continue
        if cmd is None:
            cmd = stripped.strip('"').strip()
        else:
            for kc_str in re.findall(r'\bc:(\d+)\b', stripped):
                kc = int(kc_str)
                if kc not in bindings:
                    bindings[kc] = cmd
            cmd = None
    return bindings

def make_font(size, bold=True):
    candidates = [
        "/run/current-system/sw/share/X11/fonts/DejaVuSansMono.ttf",
        "/run/current-system/sw/share/X11/fonts/LiberationMono-Regular.ttf",
    ]
    suffix = "-Bold" if bold else ""
    for pat in candidates:
        p = pat.format(suffix)
        if os.path.exists(p):
            return ImageFont.truetype(p, size)
    return ImageFont.load_default()

def rrect(draw, xy, r, fill, outline, lw=2):
    draw.rounded_rectangle(xy, radius=r, fill=fill, outline=outline, width=lw)

def render(out_path, km, binds):
    f_main  = make_font(FONT_MAIN,  bold=True)
    f_shift = make_font(FONT_SHIFT, bold=False)
    f_bind  = make_font(FONT_BIND,  bold=False)
    f_label = make_font(FONT_LABEL, bold=False)
    f_title = make_font(17,         bold=True)
    f_sub   = make_font(11,         bold=False)


    def row_px(row):
        w = 0
        for k in row:
            if isinstance(k, tuple):
                w += k[2] * (KEY_W + GAP)
            elif k == "BLOCK":
                w += BLOCK_GAP
            elif k is None:
                w += (KEY_W + GAP) * 0.5
        return w

    canvas_w = int(max(row_px(r) for r in ROWS)) + PAD * 2
    canvas_h = len(ROWS) * (KEY_H + GAP) + PAD * 2 + 70
    img  = Image.new("RGB", (canvas_w, canvas_h), BG)
    draw = ImageDraw.Draw(img)

    # Header
    draw.text((PAD, 10), "Current Keyboard Layout", font=f_title, fill=(210, 215, 255))
    draw.text((PAD, 34), f"xbindkeys: {len(binds)} bindings  |  keysyms from xmodmap -pke",
              font=f_sub, fill=(110, 118, 160))

    TOP = 58


    for r, row in enumerate(ROWS):
        x = PAD
        y = TOP + PAD + r * (KEY_H + GAP)

        for key in row:
            if key is None:
                x += (KEY_W + GAP) * 0.5
                continue
            if key == "BLOCK":
                x += BLOCK_GAP
                continue

            phys_label, kc, wmul = key
            kw = int(wmul * (KEY_W + GAP) - GAP)

            has_bind = kc in binds
            fill   = KEY_BOUND   if has_bind else KEY_DEFAULT
            stroke = KEY_BND_STR if has_bind else KEY_STROKE

            rrect(draw, (int(x), y, int(x) + kw, y + KEY_H), CORNER, fill, stroke)

            draw.text((int(x) + 5, y + 3), phys_label, font=f_label, fill=TEXT_KEYLABEL)

            syms = km.get(kc, [])
            s0 = sym(syms[0]) if len(syms) > 0 else ""
            s1 = sym(syms[1]) if len(syms) > 1 else ""

            if s0:
                draw.text((int(x) + 6, y + 18), s0, font=f_main, fill=TEXT_MAIN)
            if s1 and s1 != s0:
                draw.text((int(x) + 6, y + 36), s1, font=f_shift, fill=TEXT_SHIFT)

            if has_bind:
                cmd   = binds[kc]
                chars = max(3, kw // max(1, FONT_BIND + 1))
                short = cmd[:chars] + ("…" if len(cmd) > chars else "")
                draw.text((int(x) + 4, y + KEY_H - 14), short, font=f_bind, fill=TEXT_BIND)

            x += wmul * (KEY_W + GAP)

    lx = PAD
    ly = canvas_h - 22
    for fill, stroke, label in [
        (KEY_DEFAULT, KEY_STROKE,   "Live XModMap Layout"),
        (KEY_BOUND,   KEY_BND_STR,  "XBindKeys Bindings (CMD shown in Purple)"),
    ]:
        rrect(draw, (lx, ly, lx + 14, ly + 14), 3, fill, stroke, 1)
        draw.text((lx + 18, ly + 1), label, font=f_sub, fill=(130, 135, 170))
        lx += 18 + int(draw.textlength(label, font=f_sub)) + 28

    img.save(out_path)
    print(f"✅  Saved → {out_path}  ({canvas_w}×{canvas_h}px)")


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Render live Xorg keyboard layout to PNG")
    ap.add_argument("--output", "-o", default="keyboard_layout.png",
                    help="Output PNG path (default: keyboard_layout.png)")
    args = ap.parse_args()

    print("Reading xmodmap -pke …")
    km = get_xmodmap()
    print(f"  {len(km)} keycodes loaded.")

    print("Reading ~/.my-input-remappings/xbindkeys/global ...")
    binds = get_xbindkeys()
    print(f"  {len(binds)} xbindkeys bindings found.")

    print("Rendering …")
    render(args.output, km, binds)

import datetime
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_powerline,
)
import socket

timer_id = None


def is_connected():
    # https://stackoverflow.com/questions/20913411/test-if-an-internet-connection-is-present-in-python
    try:
        # connect to the host -- tells us if the host is actually
        # reachable
        sock = socket.create_connection(("1.1.1.1", 53))
    except OSError:
        return False
    finally:
        if sock:
            sock.close()
            return True
    return False


def internet_string():
    if is_connected():
        return "直"
    else:
        return "睊"

def weather_string():
    # Show the contents of /tmp/weather.txt
    try:
        with open("/tmp/weather.txt", "r") as f:
            return f.read()
    except:
        return "摒"


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id

    # if timer_id is None:
    #     timer_id = add_timer(_redraw_tab_bar, 2.0, True)
    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    if is_last:
        draw_right_status(draw_data, screen)
    return screen.cursor.x


def draw_right_status(draw_data: DrawData, screen: Screen) -> None:
    # The tabs may have left some formats enabled. Disable them now.
    draw_attributed_string(Formatter.reset, screen)
    cells = create_cells()
    # Drop cells that wont fit
    while True:
        if not cells:
            return
        padding = screen.columns - screen.cursor.x - \
            sum(len(c) + 4 for c in cells)
        if padding >= 0:
            break
        cells = cells[1:]

    if padding:
        screen.draw(" " * padding)

    tab_bg = as_rgb(int(draw_data.inactive_bg))
    tab_fg = as_rgb(int(draw_data.inactive_fg))
    tab_bg_active = as_rgb(int(draw_data.active_bg))

    for cell in cells:
        # Draw the separator
        screen.cursor.fg = tab_fg
        screen.draw(" | ")
        screen.cursor.fg = tab_bg_active
        screen.cursor.bg = tab_bg
        screen.draw(f"{cell}")


def create_cells() -> list[str]:
    now = datetime.datetime.now()
    return [
        # internet_string(),
        weather_string(),
        now.strftime("%d·%m·%Y ~ %H·%M"),
    ]

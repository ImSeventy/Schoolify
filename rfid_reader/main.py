import asyncio
from datetime import datetime
import json
import logging
from logging.handlers import TimedRotatingFileHandler
import os
from colorlog import ColoredFormatter
from lib.serial_reader import SerialReader
from lib.ws_server.server import Server

with open("server_config.json") as f:
    config = json.load(f)


console_format = "%(log_color)s[%(asctime)s] [%(module)s] [%(funcName)s] [%(levelname)s]: %(message)s %(reset)s"
console_stdout = logging.StreamHandler()
console_stdout.setLevel(logging.INFO)
console_stdout.setFormatter(ColoredFormatter(console_format))

logging.basicConfig(
    level=logging.DEBUG,
    datefmt="%I:%M:%S %p",
    format="[%(asctime)s] [%(module)s] [%(funcName)s] [%(levelname)s]: %(message)s",
    handlers=[console_stdout],
    force=True,
)

def DEBUG_FILTER(record):
    if not (
        record.funcName in ("write_frame_sync", "read_frame", "keepalive_ping")
    ):
        return True

    _msg = record.getMessage()
    return (
        _msg[1:6] not in (" PING", " PONG", r"% rec", r"% sen")
        or ' TEXT \'{"action": "0xFFF' != _msg[1:25]
    )

console_stdout.addFilter(DEBUG_FILTER)

port = SerialReader(
    config["serial_port"],
    config["baud_rate"],
)

server = Server(
    config["url"],
    config["port"],
    port,
)

try:
    asyncio.run(server.start())
except KeyboardInterrupt:
    os.rename(
        "./logs/latest.log",
        f"./logs/server-{datetime.now():%h-%d-%H-%M-%S}.log",
    )
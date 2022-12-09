import asyncio
from lib.serial_reader import SerialReader
from lib.ws_server.server import Server

with open("config.json") as f:
    config = json.load(f)




port = SerialReader(
    "COM3",
    9600,
)

server = Server(
    config["url"],
    config["port"],
    port,
)

asyncio.run(server.start())
import asyncio
from websockets import WebSocketServerProtocol
from lib.serial_reader import SerialReader



class ServerHandler:
    def __init__(self, serial_port: SerialReader) -> None:
        self.serial_port = serial_port
        self.subscribers = set()

    def subscribe(self, websocket: WebSocketServerProtocol):
        self.subscribers.add(websocket)

    def unsubscribe(self, websocket: WebSocketServerProtocol):
        self.subscribers.discard(websocket)

    async def start_loop(self):
        for rfid_value in await asyncio.to_thread(self.serial_port.values_generator):
            for subscriber in self.subscribers:
                await subscriber.send(str(rfid_value))

    def start(self):
        asyncio.run(self.start_loop())
    
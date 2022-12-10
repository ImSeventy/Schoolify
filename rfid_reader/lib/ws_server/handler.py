import asyncio
import logging
from websockets import WebSocketServerProtocol
from lib.serial_reader import SerialReader



class ServerHandler:
    def __init__(self, serial_port: SerialReader) -> None:
        self.serial_port = serial_port
        self.subscribers = set()

    def subscribe(self, websocket: WebSocketServerProtocol):
        self.subscribers.add(websocket)

    def unsubscribe(self, websocket: WebSocketServerProtocol):
        logging.error("--- Connection Closed ---")
        logging.error(f"Remote: {websocket.remote_address}")
        logging.error(f"Local: {websocket.local_address}")
        self.subscribers.discard(websocket)

    async def start_loop(self):
        for rfid_value in await asyncio.to_thread(self.serial_port.values_generator):
            logging.info("--- Got new UUID ---")
            logging.info(f"UUID: {rfid_value}")
            logging.info(f"Sending UUID to {len(self.subscribers)} subscribers")
            for subscriber in self.subscribers:
                await subscriber.send(str(rfid_value))

    def start(self):
        asyncio.run(self.start_loop())
    
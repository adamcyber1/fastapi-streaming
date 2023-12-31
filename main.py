import asyncio
import json

from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import time

app = FastAPI()

async def generator():
    for i in range(10):
        yield "some streamed data"
        await asyncio.sleep(1) # sleep one second

def fake_data_streamer():
    for i in range(10):
        yield json.dumps({"event_id": i, "data": "some random data", "is_last_event": i == 9}) + '\n'

        time.sleep(0.5)

@app.get("/")
async def root():
    print("Received a request on /")
    return {"message": "Hello World"}
@app.get('/stream')
async def main():
    return StreamingResponse(fake_data_streamer(), media_type='application/x-ndjson')






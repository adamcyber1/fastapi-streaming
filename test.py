import json
import aiohttp
import asyncio

import requests

url = 'http://127.0.0.1:8000/'
async def get_json_events():
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as resp:
            while True:
                chunk = await resp.content.readline()
                await asyncio.sleep(1)  # artificially long delay

                if not chunk:
                    break
                yield json.loads(chunk.decode("utf-8"))


async def main():
    async for event in get_json_events():
        print(event)


asyncio.run(main())



def get_json_events_sync():
    with requests.get(url, stream=True) as r:
        for line in r.iter_lines():
            yield json.loads(line.decode("utf-8"))


for event in get_json_events_sync():
    print(event)
from telegram import Bot
from telegram.error import TelegramError
import logging
import asyncio
import json
import os
import argparse

def get_telegram_config(filename:str):
    with open(filename) as f:
        j = json.load(f)
        return j["telegram_bot_token"], j["telegram_user_id"]


async def send_message(bot_token:str, user_id:int, message:str = 'Hello, World!'):
    bot = Bot(token=bot_token)
    try:
        await bot.send_message(chat_id=user_id, text=message)
        print("Notification sent successfully!")
    except TelegramError as e:
        print(f"Error sending notification: {e}")

def run_send_message(bot_token:str, user_id:int, message:str):
    asyncio.run(send_message(bot_token, user_id, message))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
                    prog='Telegram notification bot',
                    description='Sends a notification to given user via a telegram bot',
                    epilog='remember to configure your bot and user id')
    parser.add_argument('-m', '--message')
    parser.add_argument('-c', '--config')
    args = parser.parse_args()  

    dir_path = os.path.dirname(os.path.realpath(__file__))
    bot_token, user_id = get_telegram_config(args.config)
    run_send_message(bot_token, user_id, args.message)
    


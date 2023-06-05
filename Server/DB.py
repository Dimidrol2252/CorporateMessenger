import sqlite3 as sl
import numpy as np
import datetime

import asyncio
from asyncio.windows_events import NULL
import json
from random import random
import websockets
ADMIN_ONLINE = False
con = sl.connect('server.db')

def testPrintDB():
    with con:
        #res = con.execute("SELECT * FROM USERS;") 
        res = con.execute("SELECT * FROM sqlite_master;")
        all_results = res.fetchall()
        print(all_results)

async def getUserId(user):
    with con:
        cur = con.execute("SELECT user_id FROM USERS where user_name = ?", (user,))
        res = cur.fetchone()
        if res:
            return res[0]
        else: 
            return False

async def getPassword(user):
    with con:
        cur = con.execute("SELECT password FROM USERS where user_name = ?", (user,))
        res = cur.fetchone()
        if res:
            return res[0]
        else: 
            return False

async def getPhone(user):
    with con:
        cur = con.execute("SELECT phone FROM USERS where user_name = ?", (user,))
        res = cur.fetchone()
        if res:
            return res[0]
        else: 
            return False

async def getUserByPhone(phone):
    with con:
        cur = con.execute("SELECT user_name FROM USERS where phone = ?", (phone,))
        res = cur.fetchone()
        if res:
            return res[0]
        else: 
            return False

async def addNewUser(login, password, phone):
    with con:
        try:
            if await getUserId(login):
                return -1 # Пользователь с такми логином уже существует
            elif await getUserByPhone(phone):
                return -2 # Номер телефона уже зарегистрирован
            else:
                cur = con.cursor()
                cur.execute("INSERT INTO USERS (user_name, password, phone) VALUES (?, ?, ?)", (login, password, phone))
                con.commit()
                cur.close()
                return await getUserId(login)
        except Exception as e:
            print("Exception DB module in addNewUser: ", e)

async def getChatByChatId(chatId):
    with con:
        cur = con.execute("SELECT user_id, datetime, content FROM MESSAGES where chat_id = ?", (chatId,))
        res = cur.fetchall()
        if res:
            return res
        else: 
            return False

async def lastMessageNumber(chatId):
    with con:
        cur = con.execute("SELECT max(message_number) FROM MESSAGES where chat_id = ?", (chatId,))
        res = cur.fetchall()
        if res:
            return res[0][0]
        else: 
            return False

async def insertMessage(chatName, content, user_id): #OLD
    with con:
        try:
            cur = con.cursor()
            query = """
            INSERT INTO MESSAGES (chat_id, message_number, content, user_id, datetime)
            VALUES ((SELECT chat_id FROM CHATS WHERE chat_name = ?), 
                    (SELECT COUNT(*) FROM MESSAGES WHERE chat_id = (SELECT chat_id FROM CHATS WHERE chat_name = ?)) + 1, 
                    ?, 
                    ?,
                    datetime('now'));
            """

            cur.execute(query, (chatName, chatName, content, user_id))
            con.commit()
            message_id = cur.lastrowid
            cur.close()
            return message_id
        except Exception as e:
            print("Exception DB module in insertMessage: ", e)
    

    '''
    userId1 = await getUserId(user1)
    userId2 = await getUserId(user2)

    if userId1 and userId2:
        chatId = await getChatId(userId1, userId2)
        nextMessageNumber = await lastMessageNumber(chatId)
        if nextMessageNumber:
            nextMessageNumber += 1
            with con:
                try:
                    cur = con.cursor()
                    query = "INSERT INTO MESSAGES (chat_id, message_number, content, user_id, images, datetime) VALUES (?, ?, ?, ?, ?, ?)"
                    datetimeNow = datetime.datetime.now()
                    cur.execute(query, (chatId, nextMessageNumber, content, userId1, imgPath, datetimeNow))
                    con.commit()
                    cur.close()
                    return [userId1, str(datetimeNow)]
                except Exception as e:
                    print("Exception DB module in insertMessage: ", e)
    return False
    '''

async def isAdmin(login, password):
    return login == "admin" and password == "1234" and not ADMIN_ONLINE

async def getAllChats_admin():
    with con:
        try:
            cur = con.cursor()
            query = "SELECT chat_name, count(user_id) FROM CHATS INNER JOIN USERS_CHATS USING(chat_id) GROUP BY chat_id" 
            cur = cur.execute(query)
            res = cur.fetchall()
            return res
        except Exception as e:
            print("Exception DB module in getAllChat_admin: ", e)

async def getAllUsers_admin():
    with con:
        try:
            cur = con.cursor()
            query = "SELECT user_id, user_name, password, phone FROM USERS" 
            cur = cur.execute(query)
            res = cur.fetchall()
            return res
        except Exception as e:
            print("Exception DB module in getAllChat_admin: ", e)

async def createNewChat_admin(chatName, listUsers):
    with con:
        try:
            if await getChatIdByChatName(chatName): 
                print("Чат с таким именем уже существует")
                return
            cur = con.cursor()
            query = "INSERT INTO CHATS (chat_name) VALUES (?)"
            cur.execute(query, (chatName,))
            con.commit()
            cur.close()
            await addNewUsersInChat(chatName, listUsers)
        except Exception as e:
            print("Exception DB module in createNewChat_admin: ", e)

async def addNewUsersInChat(chatName, listUsers):
    with con:
        try:
            chatId = await getChatIdByChatName(chatName) 
            for user in listUsers:
                userId = await getUserId(user)
                cur = con.cursor()
                query = "INSERT INTO USERS_CHATS (chat_id, user_id) VALUES (?, ?)"
                cur.execute(query, (chatId, userId))
                con.commit()
                cur.close()
        except Exception as e:
            print("Exception DB module in addNweUsersInChat: ", e)

async def getChatIdByChatName(chatName):
    with con:
        cur = con.execute("SELECT chat_id FROM CHATS where chat_name = ?", (chatName,))
        res = cur.fetchone()
        if res:
            return res[0]
        else: 
            return False

async def deleteChat_admin(chatName):
    with con:
        try:
            cur = con.cursor()
            query = "DELETE FROM CHATS WHERE chat_name=?"
            cur.execute("PRAGMA foreign_keys=ON")
            cur.execute(query, (chatName,))
            con.commit()
            cur.close()
        except Exception as e:
            print("Exception DB module in deleteChat_admin: ", e)

async def deleteUser_admin(userName):
    with con:
        try:
            cur = con.cursor()
            query = "DELETE FROM USERS WHERE user_name=?"
            cur.execute("PRAGMA foreign_keys=ON")
            cur.execute(query, (userName,))
            con.commit()
            cur.close()
        except Exception as e:
            print("Exception DB module in deleteUser_admin: ", e)

async def getAllChats_user(userID):
    with con:
        try:
            cur = con.cursor()
            query = "SELECT chat_name FROM CHATS INNER JOIN USERS_CHATS USING(chat_id) WHERE user_id = ?" 
            cur = cur.execute(query, (userID,))
            res = cur.fetchall()
            return res
        except Exception as e:
            print("Exception DB module in getAllChats_user: ", e)

async def getMessagesChat(chatName):
    with con:
        try:
            cur = con.cursor()
            query = """
                    SELECT MESSAGES.message_number, MESSAGES.content, MESSAGES.datetime, USERS.user_name, MESSAGES.message_id,
                    (SELECT COUNT(*) FROM IMAGES WHERE IMAGES.message_id = MESSAGES.message_id) AS image_count
                    FROM MESSAGES
                    INNER JOIN CHATS ON MESSAGES.chat_id = CHATS.chat_id
                    INNER JOIN USERS ON MESSAGES.user_id = USERS.user_id
                    WHERE CHATS.chat_name = ?;
                    """
            cur = cur.execute(query, (chatName,))
            res = cur.fetchall()
            return res
        except Exception as e:
            print("Exception DB module in getMessagesChat: ", e)
    
async def getMessageFromId(message_id):
    with con:
        try:
            cur = con.cursor()
            query = """
                    SELECT MESSAGES.message_number, MESSAGES.content, MESSAGES.datetime, USERS.user_name, MESSAGES.message_id,
                    (SELECT COUNT(*) FROM IMAGES WHERE IMAGES.message_id = MESSAGES.message_id) AS image_count
                    FROM MESSAGES
                    INNER JOIN USERS ON MESSAGES.user_id = USERS.user_id
                    WHERE MESSAGES.message_id = ?
                    """
            cur = cur.execute(query, (message_id,))
            res = cur.fetchone()
            return res
        except Exception as e:
            print("Exception DB module in getMessageFromId: ", e)

async def getNameUsersFromChat(chatName):
    with con:
        try:
            cur = con.cursor()
            query = """
                    SELECT USERS.user_name
                    FROM USERS
                    INNER JOIN USERS_CHATS ON USERS.user_id = USERS_CHATS.user_id
                    INNER JOIN CHATS ON USERS_CHATS.chat_id = CHATS.chat_id
                    WHERE CHATS.chat_name = ?;
                    """
            cur = cur.execute(query, (chatName,))
            res = cur.fetchall()
            return res
        except Exception as e:
            print("Exception DB module in getNameUsersFromChat: ", e)

async def insertImagesPath(message_id, images_path):
    with con:
        try:
            cur = con.cursor()
            query = "INSERT INTO IMAGES (message_id, image_path) VALUES (?, ?)"
            cur.execute(query, (message_id, images_path))
            con.commit()
            cur.close()
        except Exception as e:
            print("Exception DB module in insertImagesPath: ", e)

if __name__ == '__main__':

    async def hello(websocket, path):
        await createNewChat_admin("TESTtest", ['TestUserName'])

    start_server = websockets.serve(hello, "127.0.0.1", 8080)
    print("Вроде запущено")

    asyncio.get_event_loop().run_until_complete(start_server)
    asyncio.get_event_loop().run_forever()
    
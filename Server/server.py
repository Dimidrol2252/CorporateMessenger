import asyncio
from asyncio.windows_events import NULL
import json
from random import random
import websockets
import datetime
import DB

cid = 0
counter = 0
onlineUsers = []
onlineUsersWs = []

async def get_key(d, value):
    for k, v in d.items():
        if v == value:
            return k

async def get_ws(user):
    if user in onlineUsers:
        return onlineUsersWs[onlineUsers.index(user)]
    else:
        return NULL

async def mesSendForWs(ws, mesSend):
    if isinstance(mesSend, dict):
        await ws.send(json.dumps(mesSend).encode('utf-8')) 
    else:
        print("ТУТ бинарные данные?")

async def checkLogin(mesGet,websocket):
    mesSend = NULL

    if await DB.isAdmin(mesGet['login'], mesGet['pass']):
        print("Да здравствует админ!")
        DB.ADMIN_ONLINE = True
        mesSend = {
            "type": "dataForAdmin",
            "infoAllChats": await DB.getAllChats_admin(),
            "infoAllUsers": await DB.getAllUsers_admin(),
        }
        await mesSendForWs(websocket, mesSend)
        return "ADMIN"

    userId = await DB.getUserId(mesGet['login'])
    if userId:
        if mesGet['login'] in onlineUsers:
            mesSend = {
            "type": "login",
            "res": 2
            }
            print('пользователь уже в сети')

        elif await DB.getPassword(mesGet['login']) == mesGet['pass']:
            onlineUsers.append(mesGet['login'])
            onlineUsersWs.insert(onlineUsers.index(mesGet['login']), websocket)
            mesSend = {
                "type": "login",
                "login": mesGet['login'],
                "res": 1,
                "userId": userId,
                "listChats": await DB.getAllChats_user(userId)
            }
            print(mesGet['login'] + ' logged in')

            await mesSendForWs(websocket, mesSend)
            await sendMessagesChats(websocket, mesSend['listChats'])
            return mesGet['login'] 
        else:
            mesSend = {
            "type": "login",
            "res": 0
            }
            print('пароль неверный')
    else:
        mesSend = {
            "type": "login",
            "res": 0
        }
        print('логин не найден')

    await mesSendForWs(websocket, mesSend)
    return False

async def registration(mesGet,websocket):
    mesSend = NULL
    result = await DB.addNewUser(mesGet['login'], mesGet['password'], mesGet['phone'])
    if mesGet['chat']:
        await DB.addNewUsersInChat(mesGet['chat'], [mesGet['login']])
    mesSend = {
        "type": "resultRegistration",
        "result": result
    }
    await mesSendForWs(websocket,mesSend)
    if result > 0:
        mesSend = NULL
        mesSend = {
            "type": "dataForAdmin",
            "infoAllChats": await DB.getAllChats_admin(),
            "infoAllUsers": await DB.getAllUsers_admin(),
        }
        await mesSendForWs(websocket, mesSend)

        
async def getMessage(mesGet, websocket):
    message_id = await DB.insertMessage(mesGet["chatName"], mesGet["content"], mesGet["user_id"])
    
    mesSend = NULL
    if "list_sizes_imgs" in mesGet:
        for size_img in mesGet["list_sizes_imgs"]:
            imgName = ('IMG_' + str(datetime.datetime.now()) + '.png').replace(' ', '_').replace(':', '-')
            with open(imgName, 'wb') as f:
                print('start')
                bin_size_img = 0
                while size_img != bin_size_img:
                    binMes = await websocket.recv()
                    bin_size_img += len(binMes)
                    f.write(binMes)
                print('end')
            await DB.insertImagesPath(message_id, imgName)
            
    newMessage = await DB.getMessageFromId(message_id)
    mesSend = {
        "type": "getMessage",
        "chatName": mesGet["chatName"],
        "newMessage": newMessage
    }

    namesUsersForChat = await DB.getNameUsersFromChat(mesGet["chatName"])
    print(onlineUsers)
    for name in namesUsersForChat:
        if name[0] in onlineUsers:
            await mesSendForWs(await get_ws(name[0]), mesSend)
    
async def createNewChat_admin(mesGet, websocket):
    await DB.createNewChat_admin(mesGet['chatName'], mesGet['listUsers'])
    mesSend = NULL
    mesSend = {
        "type": "dataForAdmin",
        "infoAllChats": await DB.getAllChats_admin(),
        "infoAllUsers": await DB.getAllUsers_admin(),
    }
    await mesSendForWs(websocket, mesSend)
    
async def deleteChat_admin(mesGet, websocket):
    await DB.deleteChat_admin(mesGet['chatName'])
    mesSend = NULL
    mesSend = {
        "type": "dataForAdmin",
        "infoAllChats": await DB.getAllChats_admin(),
        "infoAllUsers": await DB.getAllUsers_admin(),
    }
    await mesSendForWs(websocket, mesSend)

async def deleteUser_admin(mesGet, websocket):
    await DB.deleteUser_admin(mesGet['userName'])
    
    mesSend = {
        "type": "dataForAdmin",
        "infoAllChats": await DB.getAllChats_admin(),
        "infoAllUsers": await DB.getAllUsers_admin(),
    }
    await mesSendForWs(websocket, mesSend)


async def sendMessagesChats(websocket, listChats):
    mesSend = NULL
    mesSend = {
        "type": "allMessagesChats",
    }
    for chat in listChats:
        mesSend[chat[0]] = await DB.getMessagesChat(chat[0])

    await mesSendForWs(websocket, mesSend)

async def hello(websocket, path):
    while (True):
        try:
            mesGet = await websocket.recv()
            mesGet = json.loads(mesGet.decode())
            print(mesGet)
            if (isinstance(mesGet, dict)):
                typemsg = mesGet['type']
                if typemsg == 'login':
                    cid = await checkLogin(mesGet,websocket)
                elif typemsg == 'registrationUser':
                    await registration(mesGet, websocket)
                elif typemsg == 'sendMessage':
                    await getMessage(mesGet, websocket)
                elif typemsg == 'logout':
                    raise Exception
                elif typemsg ==  'createNewChat_admin':
                    await createNewChat_admin(mesGet, websocket)
                elif typemsg == 'deleteChat_admin':
                    await deleteChat_admin(mesGet, websocket)
                elif typemsg == 'deleteUser_admin':
                    await deleteUser_admin(mesGet, websocket)

        except Exception as e:
            if cid == "ADMIN":
                DB.ADMIN_ONLINE = False
                print("Админ вышел!", e)
            elif cid:
                leftUs = cid 

                print(onlineUsersWs[onlineUsers.index(leftUs)])
                onlineUsersWs.pop(onlineUsers.index(leftUs))

                print(onlineUsers.index(leftUs))
                onlineUsers.remove(leftUs)


                print(f">> {leftUs} отключен: ", e)
            else:
                print("Ушёл, даже не авторизовался", e)
            break
        

print("local: 0, global: 1")
param = "0"
param = input()
if param == "0":
    start_server = websockets.serve(hello, "127.0.0.1", 8080)
elif param == "1":
    start_server = websockets.serve(hello, "0.0.0.0", 8080)
print("Вроде запущено")

asyncio.get_event_loop().run_until_complete(start_server)
asyncio.get_event_loop().run_forever()
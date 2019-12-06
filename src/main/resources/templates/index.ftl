<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0">
    <title>Chat</title>
</head>
<body>

<div id="username-page">
    <div class="username-page-container">
        <h1 class="title">Your username:</h1>
        <form id="usernameForm" name="usernameForm">
            <div class="form-group">
                <input type="text" id="name" placeholder="Username" autocomplete="off" class="form-control" />
            </div>
            <div class="form-group">
                <button type="submit" class="accent username-submit">Start Chatting</button>
            </div>
        </form>
    </div>
</div>

<div id="chat-page" class="hidden">
    <div class="chat-container">
        <div class="chat-header">
            <h2>Chat</h2>
        </div>
        <ul id="messageArea">

        </ul>
        <form id="messageForm" name="messageForm" nameForm="messageForm">
            <div class="form-group">
                <div class="input-group clearfix">
                    <input type="text" id="message" placeholder="Type a message..." autocomplete="off" class="form-control"/>
                    <button type="submit" class="primary">Send</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.4/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<script>'use strict';

    var usernamePage = document.querySelector('#username-page');
    var chatPage = document.querySelector('#chat-page');
    var usernameForm = document.querySelector('#usernameForm');
    var messageForm = document.querySelector('#messageForm');
    var messageInput = document.querySelector('#message');
    var messageArea = document.querySelector('#messageArea');

    var stompClient = null;
    var username = null;


    function connect(event) {
        username = document.querySelector('#name').value.trim();

        if(username) {
            usernamePage.classList.add('hidden');
            chatPage.classList.remove('hidden');

            var socket = new SockJS('/ws');
            stompClient = Stomp.over(socket);

            stompClient.connect({}, onConnected, onError);
        }
        event.preventDefault();
    }


    function onConnected() {
        // Subscribe to the Public Topic
        stompClient.subscribe('/topic/public', onMessageReceived);

        // Tell your username to the server
        stompClient.send("/app/chat.addUser",
            {},
            JSON.stringify({sender: username, type: 'JOIN'})
        )

    }


    function onError(error) {
        connectingElement.textContent = 'Could not connect to WebSocket server. Please refresh this page to try again!';
        connectingElement.style.color = 'red';
    }


    function sendMessage(event) {
        var messageContent = messageInput.value.trim();

        if(messageContent && stompClient) {
            var chatMessage = {
                sender: username,
                content: messageInput.value,
                type: 'CHAT'
            };

            stompClient.send("/app/chat.sendMessage", {}, JSON.stringify(chatMessage));
            messageInput.value = '';
        }
        event.preventDefault();
    }


    function onMessageReceived(payload) {
        var message = JSON.parse(payload.body);

        var messageElement = document.createElement('li');

        if(message.type === 'JOIN') {
            messageElement.classList.add('event-message');
            message.content = message.sender + ' joined chat';
        } else if (message.type === 'LEAVE') {
            messageElement.classList.add('event-message');
            message.content = message.sender + ' left chat';
        } else {
            messageElement.classList.add('chat-message');

            var usernameElement = document.createElement('span');
            var usernameText = document.createTextNode(message.sender);
            usernameElement.appendChild(usernameText);
            messageElement.appendChild(usernameElement);
        }

        var textElement = document.createElement('p');
        var messageText = document.createTextNode(message.content);
        textElement.appendChild(messageText);

        messageElement.appendChild(textElement);

        messageArea.appendChild(messageElement);
        messageArea.scrollTop = messageArea.scrollHeight;
    }

    usernameForm.addEventListener('submit', connect, true)
    messageForm.addEventListener('submit', sendMessage, true)
</script>
</body>
</html>
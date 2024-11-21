<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script src="https://cdn.jsdelivr.net/sockjs/1/sockjs.min.js"></script>

<style>
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        margin: 0;
        padding: 0;
        height: 100vh;
        font-family: Arial, sans-serif;
    }

    .mobile-frame {
        width: 360px;  /* Typical mobile width */
        height: 640px; /* Typical mobile height */
        border-radius: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        overflow: hidden;
        background-color: white;
        display: flex;
        flex-direction: column;
    }
    
    .chat-header {
        padding: 10px;
        background-color: #0066cc;
        color: white;
        text-align: center;
        font-weight: bold;
        font-size: 1.2em;
    }
    
    .chat-messages {
        flex-grow: 1;
        padding: 10px;
        overflow-y: auto;
        background-color: #f5f5f5;
        display: flex;
        flex-direction: column;
    }

    .message {
        margin: 10px 0;
        padding: 8px 12px;
        padding-right: 0;
        border-radius: 12px;
        max-width: 70%;
        font-size: 0.9em;
        display: inline-block;
        text-align: left;
    }

    .counselor-message {
        background-color: #ffffff;
        align-self: flex-start; /* Align to the left */
    }
    
    .user-message {
        background-color: #d1e7dd;
        align-self: flex-end; /* Align to the right */
    }
    
    .chat-footer {
        padding: 10px;
        background-color: white;
        display: flex;
        align-items: center;
    }

    .chat-footer input[type="text"] {
        flex-grow: 1;
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        margin-right: 8px;
        font-size: 0.9em;
    }

    .chat-footer button {
        padding: 8px 16px;
        background-color: #0066cc;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 0.9em;
    }

    .chat-footer button:hover {
        background-color: #005bb5;
    }
</style>
</head>
<body>

<div class="mobile-frame">
    <div class="chat-header">1:1 상담톡</div>
    <div class="chat-messages">
        <div class="message counselor-message">안녕하세요! 무엇을 도와드릴까요? 길게 말해도 정렬이 알아서 잘 될까요?</div>
        <div class="message user-message">안녕하세요! 상담 신청하고 싶어요. 길게 말해도 정렬이 알아서 잘 될까요?</div>
    </div>
    <div class="chat-footer">
        <input type="text" placeholder="메시지를 입력하세요..." id="messageInput">
        <button onclick="sendMessage()">전송</button>
    </div>
</div>




</body>
</html>
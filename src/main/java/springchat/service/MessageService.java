package springchat.service;

import springchat.model.ChatMessage;

import java.util.List;

public interface MessageService {

    List<ChatMessage> findAllByRoomId(String roomId);

    void save(ChatMessage chatMessage);

    List<ChatMessage> findAll();

    List<ChatMessage> findAllRoomIdUnique();

    List<ChatMessage> findChatMessageByRoomsId(List<String> roomId);

    List<String> findAllRoomId();
}

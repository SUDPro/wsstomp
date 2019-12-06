package ru.itis.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ru.itis.model.ChatMessage;
import ru.itis.repository.MessageRepository;

import java.util.List;

@Service
public class MessageService {

    @Autowired
    MessageRepository repository;

    public List<ChatMessage> getAllMessages(){
        return repository.findAll();
    }

    public void saveMessage(ChatMessage message){
        repository.save(message);
    }
}

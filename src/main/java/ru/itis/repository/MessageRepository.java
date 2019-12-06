package ru.itis.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ru.itis.model.ChatMessage;

@Repository
public interface MessageRepository extends JpaRepository<ChatMessage, Long> {
}

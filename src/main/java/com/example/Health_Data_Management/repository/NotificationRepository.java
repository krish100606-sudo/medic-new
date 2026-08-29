package com.example.Health_Data_Management.repository;



import com.example.Health_Data_Management.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository
        extends JpaRepository<Notification, Long> {

    // Get all notifications for a user
    List<Notification> findByUserId(Long userId);

    // Get unread notifications
    List<Notification> findByUserIdAndRead(
            Long userId,
            boolean read
    );

    // Get notifications by type
    List<Notification> findByUserIdAndNotificationType(
            Long userId,
            String notificationType
    );

    // Count unread notifications
    long countByUserIdAndRead(
            Long userId,
            boolean read
    );
}

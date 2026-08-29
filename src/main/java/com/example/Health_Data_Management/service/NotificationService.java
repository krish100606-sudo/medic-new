package com.example.Health_Data_Management.service;



import com.example.Health_Data_Management.entity.Notification;
import com.example.Health_Data_Management.entity.User;
import com.example.Health_Data_Management.repository.NotificationRepository;
import com.example.Health_Data_Management.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    public NotificationService(
            NotificationRepository notificationRepository,
            UserRepository userRepository) {

        this.notificationRepository = notificationRepository;
        this.userRepository = userRepository;
    }

    // ---------------------------------------------------------
    // CREATE NOTIFICATION
    // ---------------------------------------------------------

    public Notification createNotification(
            Long userId,
            String title,
            String message,
            String notificationType) {

        User user = userRepository.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));

        if (title == null || title.isBlank()) {
            throw new RuntimeException(
                    "Notification title is required");
        }

        if (message == null || message.isBlank()) {
            throw new RuntimeException(
                    "Notification message is required");
        }

        Notification notification = new Notification();

        notification.setUser(user);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setNotificationType(
                notificationType
        );
        notification.setRead(false);

        return notificationRepository.save(notification);
    }

    // ---------------------------------------------------------
    // CREATE FROM NOTIFICATION OBJECT
    // ---------------------------------------------------------

    public Notification createNotification(
            Long userId,
            Notification notification) {

        User user = userRepository.findById(userId)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));

        if (notification.getTitle() == null ||
                notification.getTitle().isBlank()) {

            throw new RuntimeException(
                    "Notification title is required");
        }

        if (notification.getMessage() == null ||
                notification.getMessage().isBlank()) {

            throw new RuntimeException(
                    "Notification message is required");
        }

        notification.setUser(user);
        notification.setRead(false);

        return notificationRepository.save(notification);
    }

    // ---------------------------------------------------------
    // GET NOTIFICATION BY ID
    // ---------------------------------------------------------

    public Optional<Notification> findById(Long id) {

        return notificationRepository.findById(id);
    }

    // ---------------------------------------------------------
    // GET ALL NOTIFICATIONS
    // ---------------------------------------------------------

    public List<Notification> getAllNotifications() {

        return notificationRepository.findAll();
    }

    // ---------------------------------------------------------
    // GET USER NOTIFICATIONS
    // ---------------------------------------------------------

    public List<Notification> getUserNotifications(
            Long userId) {

        return notificationRepository
                .findByUserId(userId);
    }

    // ---------------------------------------------------------
    // GET UNREAD NOTIFICATIONS
    // ---------------------------------------------------------

    public List<Notification> getUnreadNotifications(
            Long userId) {

        return notificationRepository
                .findByUserIdAndRead(
                        userId,
                        false
                );
    }

    // ---------------------------------------------------------
    // GET READ NOTIFICATIONS
    // ---------------------------------------------------------

    public List<Notification> getReadNotifications(
            Long userId) {

        return notificationRepository
                .findByUserIdAndRead(
                        userId,
                        true
                );
    }

    // ---------------------------------------------------------
    // GET NOTIFICATIONS BY TYPE
    // ---------------------------------------------------------

    public List<Notification> getNotificationsByType(
            Long userId,
            String notificationType) {

        return notificationRepository
                .findByUserIdAndNotificationType(
                        userId,
                        notificationType
                );
    }

    // ---------------------------------------------------------
    // COUNT UNREAD NOTIFICATIONS
    // ---------------------------------------------------------

    public long countUnreadNotifications(
            Long userId) {

        return notificationRepository
                .countByUserIdAndRead(
                        userId,
                        false
                );
    }

    // ---------------------------------------------------------
    // MARK AS READ
    // ---------------------------------------------------------

    public Notification markAsRead(Long id) {

        Notification notification =
                getNotificationOrThrow(id);

        notification.setRead(true);

        return notificationRepository.save(notification);
    }

    // ---------------------------------------------------------
    // MARK AS UNREAD
    // ---------------------------------------------------------

    public Notification markAsUnread(Long id) {

        Notification notification =
                getNotificationOrThrow(id);

        notification.setRead(false);

        return notificationRepository.save(notification);
    }

    // ---------------------------------------------------------
    // MARK ALL USER NOTIFICATIONS AS READ
    // ---------------------------------------------------------

    public List<Notification> markAllAsRead(
            Long userId) {

        List<Notification> notifications =
                notificationRepository
                        .findByUserIdAndRead(
                                userId,
                                false
                        );

        for (Notification notification : notifications) {
            notification.setRead(true);
        }

        return notificationRepository.saveAll(
                notifications
        );
    }

    // ---------------------------------------------------------
    // DELETE NOTIFICATION
    // ---------------------------------------------------------

    public void deleteNotification(Long id) {

        if (!notificationRepository.existsById(id)) {

            throw new RuntimeException(
                    "Notification not found");
        }

        notificationRepository.deleteById(id);
    }

    // ---------------------------------------------------------
    // HELPER METHOD
    // ---------------------------------------------------------

    private Notification getNotificationOrThrow(
            Long id) {

        return notificationRepository.findById(id)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Notification not found"));
    }
}

package com.example.Health_Data_Management.controller;



import com.example.Health_Data_Management.entity.Notification;
import com.example.Health_Data_Management.service.NotificationService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(
            NotificationService notificationService) {

        this.notificationService = notificationService;
    }

    // ---------------------------------------------------------
    // CREATE NOTIFICATION
    // POST /api/notifications/user/{userId}
    // ---------------------------------------------------------

    @PostMapping("/user/{userId}")
    public ResponseEntity<Notification> createNotification(
            @PathVariable Long userId,
            @RequestBody Notification notification) {

        return ResponseEntity.ok(
                notificationService.createNotification(
                        userId,
                        notification
                )
        );
    }

    // ---------------------------------------------------------
    // GET ALL NOTIFICATIONS
    // GET /api/notifications
    // ---------------------------------------------------------

    @GetMapping
    public ResponseEntity<List<Notification>>
    getAllNotifications() {

        return ResponseEntity.ok(
                notificationService.getAllNotifications()
        );
    }

    // ---------------------------------------------------------
    // GET NOTIFICATION BY ID
    // GET /api/notifications/{id}
    // ---------------------------------------------------------

    @GetMapping("/{id}")
    public ResponseEntity<Notification> getNotification(
            @PathVariable Long id) {

        return notificationService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // ---------------------------------------------------------
    // GET USER NOTIFICATIONS
    // GET /api/notifications/user/{userId}
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Notification>>
    getUserNotifications(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                notificationService
                        .getUserNotifications(userId)
        );
    }

    // ---------------------------------------------------------
    // GET UNREAD NOTIFICATIONS
    // GET /api/notifications/user/{userId}/unread
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}/unread")
    public ResponseEntity<List<Notification>>
    getUnreadNotifications(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                notificationService
                        .getUnreadNotifications(userId)
        );
    }

    // ---------------------------------------------------------
    // GET READ NOTIFICATIONS
    // GET /api/notifications/user/{userId}/read
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}/read")
    public ResponseEntity<List<Notification>>
    getReadNotifications(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                notificationService
                        .getReadNotifications(userId)
        );
    }

    // ---------------------------------------------------------
    // GET NOTIFICATIONS BY TYPE
    // GET /api/notifications/user/{userId}/type/{type}
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}/type/{type}")
    public ResponseEntity<List<Notification>>
    getNotificationsByType(
            @PathVariable Long userId,
            @PathVariable String type) {

        return ResponseEntity.ok(
                notificationService
                        .getNotificationsByType(
                                userId,
                                type
                        )
        );
    }

    // ---------------------------------------------------------
    // COUNT UNREAD NOTIFICATIONS
    // GET /api/notifications/user/{userId}/unread/count
    // ---------------------------------------------------------

    @GetMapping("/user/{userId}/unread/count")
    public ResponseEntity<Long> countUnreadNotifications(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                notificationService
                        .countUnreadNotifications(userId)
        );
    }

    // ---------------------------------------------------------
    // MARK AS READ
    // PUT /api/notifications/{id}/read
    // ---------------------------------------------------------

    @PutMapping("/{id}/read")
    public ResponseEntity<Notification> markAsRead(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                notificationService.markAsRead(id)
        );
    }

    // ---------------------------------------------------------
    // MARK AS UNREAD
    // PUT /api/notifications/{id}/unread
    // ---------------------------------------------------------

    @PutMapping("/{id}/unread")
    public ResponseEntity<Notification> markAsUnread(
            @PathVariable Long id) {

        return ResponseEntity.ok(
                notificationService.markAsUnread(id)
        );
    }

    // ---------------------------------------------------------
    // MARK ALL AS READ
    // PUT /api/notifications/user/{userId}/read-all
    // ---------------------------------------------------------

    @PutMapping("/user/{userId}/read-all")
    public ResponseEntity<List<Notification>>
    markAllAsRead(
            @PathVariable Long userId) {

        return ResponseEntity.ok(
                notificationService.markAllAsRead(
                        userId
                )
        );
    }

    // ---------------------------------------------------------
    // DELETE NOTIFICATION
    // DELETE /api/notifications/{id}
    // ---------------------------------------------------------

    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteNotification(
            @PathVariable Long id) {

        notificationService.deleteNotification(id);

        return ResponseEntity.ok(
                "Notification deleted successfully"
        );
    }
}

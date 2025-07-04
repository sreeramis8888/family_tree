const express = require("express");
const router = express.Router();
const chatController = require("./chat.controller");
const { authMiddleware } = require("../../middlewares/auth.middleware");
const chatValidators = require("./chat.validators");

// Apply auth middleware to all chat routes
// router.use(authMiddleware);

// Conversation routes
router.get(
  "/conversations",
  chatValidators.validatePagination,
  chatController.getConversations
);
router.get(
  "/conversations/direct/:recipientId",
  chatValidators.validateRecipientId,
  chatController.getOrCreateDirectConversation
);
router.post(
  "/conversations/group",
  chatValidators.createGroupConversation,
  chatController.createGroupConversation
);
router.put(
  "/conversations/:conversationId/archive",
  chatValidators.validateConversationId,
  chatController.toggleArchiveConversation
);

// Participant management
router.post(
  "/conversations/:conversationId/participants",
  chatValidators.validateConversationId,
  chatValidators.addParticipants,
  chatController.addParticipants
);
router.delete(
  "/conversations/:conversationId/participants/:participantId",
  chatValidators.validateConversationId,
  chatValidators.validateParticipantId,
  chatController.removeParticipant
);

// Message routes
router.get(
  "/conversations/:conversationId/messages",
  chatValidators.validateConversationId,
  chatValidators.validatePagination,
  chatController.getMessages
);
router.post(
  "/conversations/:conversationId/messages",
  chatValidators.validateConversationId,
  chatValidators.sendMessage,
  chatController.sendMessage
);
router.put(
  "/conversations/:conversationId/messages/read",
  chatValidators.validateConversationId,
  chatValidators.markMessagesAsRead,
  chatController.markMessagesAsRead
);
router.put(
  "/messages/:messageId",
  chatValidators.validateMessageId,
  chatValidators.editMessage,
  chatController.editMessage
);
router.delete(
  "/messages/:messageId",
  chatValidators.validateMessageId,
  chatValidators.deleteMessage,
  chatController.deleteMessage
);

module.exports = router;

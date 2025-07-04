const { Conversation, Message } = require("./chat.model");
const Person = require("../person/person.model");
const Family = require("../family/family.model");
const response_handler = require("../../helpers/responseHandler");
const mongoose = require("mongoose");

// Get all conversations for a user
const getConversations = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, limit = 20, type, search } = req.query;

    let matchConditions = {
      "participants.userId": new mongoose.Types.ObjectId(userId),
      "participants.isActive": true,
    };

    if (type) {
      matchConditions.type = type;
    }

    if (search) {
      matchConditions.$or = [
        { name: { $regex: search, $options: "i" } },
        { description: { $regex: search, $options: "i" } },
      ];
    }

    const conversations = await Conversation.aggregate([
      { $match: matchConditions },
      {
        $lookup: {
          from: "messages",
          localField: "lastMessage",
          foreignField: "_id",
          as: "lastMessageDetail",
        },
      },
      {
        $lookup: {
          from: "people",
          localField: "participants.userId",
          foreignField: "_id",
          as: "participantDetails",
        },
      },
      {
        $addFields: {
          lastMessageDetail: { $arrayElemAt: ["$lastMessageDetail", 0] },
          unreadCount: {
            $size: {
              $filter: {
                input: "$participants",
                cond: {
                  $and: [
                    {
                      $eq: [
                        "$$this.userId",
                        new mongoose.Types.ObjectId(userId),
                      ],
                    },
                    { $eq: ["$$this.isActive", true] },
                  ],
                },
              },
            },
          },
        },
      },
      { $sort: { lastActivity: -1 } },
      { $skip: (page - 1) * limit },
      { $limit: parseInt(limit) },
    ]);

    // Calculate unread count for each conversation
    for (let conversation of conversations) {
      const userParticipant = conversation.participants.find(
        (p) => p.userId.toString() === userId.toString()
      );

      if (userParticipant && userParticipant.lastSeenMessageId) {
        const unreadCount = await Message.countDocuments({
          conversationId: conversation._id,
          _id: { $gt: userParticipant.lastSeenMessageId },
          senderId: { $ne: userId },
        });
        conversation.unreadCount = unreadCount;
      } else {
        const unreadCount = await Message.countDocuments({
          conversationId: conversation._id,
          senderId: { $ne: userId },
        });
        conversation.unreadCount = unreadCount;
      }
    }

    return response_handler(
      res,
      200,
      "Conversations fetched successfully",
      conversations
    );
  } catch (error) {
    return response_handler(res, 500, "Error fetching conversations", {
      error: error.message,
    });
  }
};

// Get or create direct conversation
const getOrCreateDirectConversation = async (req, res) => {
  try {
    const userId = req.user.id;
    const { recipientId } = req.params;

    // Check if recipient exists
    const recipient = await Person.findById(recipientId);
    if (!recipient) {
      return response_handler(res, 404, "Recipient not found");
    }

    // Check if conversation already exists
    let conversation = await Conversation.findOne({
      type: "direct",
      "participants.userId": { $all: [userId, recipientId] },
    })
      .populate("participants.userId", "fullName image phone status")
      .populate("lastMessage");

    if (!conversation) {
      // Create new direct conversation
      conversation = new Conversation({
        type: "direct",
        participants: [
          { userId, role: "member" },
          { userId: recipientId, role: "member" },
        ],
        createdBy: userId,
        lastActivity: new Date(),
      });

      await conversation.save();
      await conversation.populate(
        "participants.userId",
        "fullName image phone status"
      );
    }

    return response_handler(
      res,
      200,
      "Direct conversation retrieved",
      conversation
    );
  } catch (error) {
    return response_handler(
      res,
      500,
      "Error creating/fetching direct conversation",
      {
        error: error.message,
      }
    );
  }
};

// Create group conversation
const createGroupConversation = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, description, participantIds, familyId } = req.body;

    if (!name || !participantIds || participantIds.length === 0) {
      return response_handler(res, 400, "Name and participants are required");
    }

    // Validate participants exist
    const participants = await Person.find({ _id: { $in: participantIds } });
    if (participants.length !== participantIds.length) {
      return response_handler(res, 400, "Some participants not found");
    }

    let conversationType = "group";
    let familyData = null;

    // If familyId is provided, validate and set type to family
    if (familyId) {
      familyData = await Family.findById(familyId);
      if (!familyData) {
        return response_handler(res, 404, "Family not found");
      }
      conversationType = "family";
    }

    // Create conversation
    const conversation = new Conversation({
      type: conversationType,
      name,
      description,
      familyId: familyId || undefined,
      participants: [
        { userId, role: "admin" }, // Creator is admin
        ...participantIds.map((id) => ({ userId: id, role: "member" })),
      ],
      createdBy: userId,
      lastActivity: new Date(),
    });

    await conversation.save();
    await conversation.populate(
      "participants.userId",
      "fullName image phone status"
    );

    // Create system message for group creation
    const systemMessage = new Message({
      conversationId: conversation._id,
      senderId: userId,
      content: `${req.user.fullName} created the group`,
      messageType: "system",
      metadata: {
        systemMessageType: "group_created",
      },
    });

    await systemMessage.save();
    conversation.lastMessage = systemMessage._id;
    await conversation.save();

    // Emit to all participants via socket
    const io = req.app.get("io");
    conversation.participants.forEach((participant) => {
      io.to(`user_${participant.userId}`).emit(
        "new_conversation",
        conversation
      );
    });

    return response_handler(
      res,
      201,
      "Group conversation created",
      conversation
    );
  } catch (error) {
    return response_handler(res, 500, "Error creating group conversation", {
      error: error.message,
    });
  }
};

// Get messages for a conversation
const getMessages = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId } = req.params;
    const { page = 1, limit = 50 } = req.query;

    // Check if user is participant
    const conversation = await Conversation.findById(conversationId);
    if (!conversation || !conversation.isParticipant(userId)) {
      return response_handler(res, 403, "Access denied to this conversation");
    }

    const messages = await Message.find({
      conversationId,
      $or: [
        { "deleted.isDeleted": false },
        {
          "deleted.isDeleted": true,
          "deleted.deletedFor": "sender",
          "deleted.deletedBy": { $ne: userId },
        },
      ],
    })
      .populate("senderId", "fullName image status")
      .populate("replyTo", "content senderId messageType")
      .sort({ createdAt: -1 })
      .limit(limit * 1)
      .skip((page - 1) * limit);

    // Mark messages as delivered for the requesting user
    const undeliveredMessages = messages.filter(
      (msg) =>
        !msg.isDeliveredTo(userId) &&
        msg.senderId._id.toString() !== userId.toString()
    );

    for (let message of undeliveredMessages) {
      message.markAsDelivered(userId);
      await message.save();
    }

    return response_handler(
      res,
      200,
      "Messages fetched successfully",
      messages.reverse()
    );
  } catch (error) {
    return response_handler(res, 500, "Error fetching messages", {
      error: error.message,
    });
  }
};

// Send message
const sendMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId } = req.params;
    const { content, messageType = "text", attachments, replyTo } = req.body;

    // Validate conversation and user participation
    const conversation = await Conversation.findById(conversationId);
    if (!conversation || !conversation.isParticipant(userId)) {
      return response_handler(res, 403, "Access denied to this conversation");
    }

    // Check if user can send messages (for group chats with restrictions)
    if (
      conversation.settings.onlyAdminsCanSend &&
      !conversation.isAdmin(userId)
    ) {
      return response_handler(
        res,
        403,
        "Only admins can send messages in this group"
      );
    }

    // Create message
    const message = new Message({
      conversationId,
      senderId: userId,
      content,
      messageType,
      attachments: attachments || [],
      replyTo: replyTo || undefined,
    });

    await message.save();
    await message.populate("senderId", "fullName image status");

    if (replyTo) {
      await message.populate("replyTo", "content senderId messageType");
    }

    // Update conversation last message and activity
    conversation.lastMessage = message._id;
    conversation.lastActivity = new Date();
    await conversation.save();

    // Mark as delivered for all online participants
    const io = req.app.get("io");
    const activeParticipants = conversation.getActiveParticipants();

    activeParticipants.forEach((participant) => {
      const participantId = participant.userId.toString();
      if (participantId !== userId.toString()) {
        // Emit to participant's socket room
        io.to(`user_${participantId}`).emit("new_message", {
          conversationId,
          message,
        });

        // Mark as delivered if user is online
        const userSocket = io.sockets.adapter.rooms.get(
          `user_${participantId}`
        );
        if (userSocket && userSocket.size > 0) {
          message.markAsDelivered(participantId);
        }
      }
    });

    // Save delivery status
    await message.save();

    return response_handler(res, 201, "Message sent successfully", message);
  } catch (error) {
    return response_handler(res, 500, "Error sending message", {
      error: error.message,
    });
  }
};

// Mark messages as read
const markMessagesAsRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId } = req.params;
    const { messageIds } = req.body;

    // Validate conversation
    const conversation = await Conversation.findById(conversationId);
    if (!conversation || !conversation.isParticipant(userId)) {
      return response_handler(res, 403, "Access denied to this conversation");
    }

    // Mark messages as read
    const messages = await Message.find({
      _id: { $in: messageIds },
      conversationId,
    });

    let updatedMessages = [];
    for (let message of messages) {
      if (message.markAsRead(userId)) {
        await message.save();
        updatedMessages.push(message._id);
      }
    }

    // Update user's last seen message
    const userParticipant = conversation.participants.find(
      (p) => p.userId.toString() === userId.toString()
    );
    if (userParticipant && messageIds.length > 0) {
      userParticipant.lastSeenMessageId = messageIds[messageIds.length - 1];
      await conversation.save();
    }

    // Emit read receipts to other participants
    const io = req.app.get("io");
    const activeParticipants = conversation.getActiveParticipants();

    activeParticipants.forEach((participant) => {
      const participantId = participant.userId.toString();
      if (participantId !== userId.toString()) {
        io.to(`user_${participantId}`).emit("messages_read", {
          conversationId,
          messageIds: updatedMessages,
          readBy: userId,
        });
      }
    });

    return response_handler(res, 200, "Messages marked as read", {
      updatedMessages: updatedMessages.length,
    });
  } catch (error) {
    return response_handler(res, 500, "Error marking messages as read", {
      error: error.message,
    });
  }
};

// Edit message
const editMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const { messageId } = req.params;
    const { content } = req.body;

    const message = await Message.findById(messageId);
    if (!message) {
      return response_handler(res, 404, "Message not found");
    }

    // Check if user is the sender
    if (message.senderId.toString() !== userId.toString()) {
      return response_handler(res, 403, "You can only edit your own messages");
    }

    // Check if message is not too old (e.g., 24 hours)
    const hoursSinceCreated =
      (new Date() - message.createdAt) / (1000 * 60 * 60);
    if (hoursSinceCreated > 24) {
      return response_handler(
        res,
        403,
        "Cannot edit messages older than 24 hours"
      );
    }

    // Update message
    message.edited.originalContent = message.content;
    message.content = content;
    message.edited.isEdited = true;
    message.edited.editedAt = new Date();

    await message.save();
    await message.populate("senderId", "fullName image status");

    // Emit to conversation participants
    const conversation = await Conversation.findById(message.conversationId);
    const io = req.app.get("io");
    const activeParticipants = conversation.getActiveParticipants();

    activeParticipants.forEach((participant) => {
      const participantId = participant.userId.toString();
      io.to(`user_${participantId}`).emit("message_edited", {
        conversationId: message.conversationId,
        message,
      });
    });

    return response_handler(res, 200, "Message edited successfully", message);
  } catch (error) {
    return response_handler(res, 500, "Error editing message", {
      error: error.message,
    });
  }
};

// Delete message
const deleteMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const { messageId } = req.params;
    const { deleteFor = "sender" } = req.body; // "sender" or "everyone"

    const message = await Message.findById(messageId);
    if (!message) {
      return response_handler(res, 404, "Message not found");
    }

    // Check if user is the sender or admin
    const conversation = await Conversation.findById(message.conversationId);
    const isAdmin = conversation.isAdmin(userId);
    const isSender = message.senderId.toString() === userId.toString();

    if (!isSender && !isAdmin) {
      return response_handler(res, 403, "Access denied");
    }

    // Only admins can delete for everyone, or sender within 24 hours
    if (deleteFor === "everyone" && !isAdmin) {
      const hoursSinceCreated =
        (new Date() - message.createdAt) / (1000 * 60 * 60);
      if (hoursSinceCreated > 24) {
        return response_handler(
          res,
          403,
          "Cannot delete for everyone after 24 hours"
        );
      }
    }

    // Update message
    message.deleted.isDeleted = true;
    message.deleted.deletedAt = new Date();
    message.deleted.deletedBy = userId;
    message.deleted.deletedFor = deleteFor;

    await message.save();

    // Emit to conversation participants
    const io = req.app.get("io");
    const activeParticipants = conversation.getActiveParticipants();

    activeParticipants.forEach((participant) => {
      const participantId = participant.userId.toString();
      io.to(`user_${participantId}`).emit("message_deleted", {
        conversationId: message.conversationId,
        messageId: message._id,
        deletedFor,
        deletedBy: userId,
      });
    });

    return response_handler(res, 200, "Message deleted successfully");
  } catch (error) {
    return response_handler(res, 500, "Error deleting message", {
      error: error.message,
    });
  }
};

// Add participants to group
const addParticipants = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId } = req.params;
    const { participantIds } = req.body;

    const conversation = await Conversation.findById(conversationId);
    if (!conversation) {
      return response_handler(res, 404, "Conversation not found");
    }

    // Check permissions
    if (conversation.type === "direct") {
      return response_handler(
        res,
        400,
        "Cannot add participants to direct conversation"
      );
    }

    const isAdmin = conversation.isAdmin(userId);
    const canAddMembers = conversation.settings.allowMembersToAddOthers;

    if (!isAdmin && !canAddMembers) {
      return response_handler(res, 403, "Only admins can add participants");
    }

    // Validate participants
    const participants = await Person.find({ _id: { $in: participantIds } });
    if (participants.length !== participantIds.length) {
      return response_handler(res, 400, "Some participants not found");
    }

    // Add participants
    let addedCount = 0;
    participantIds.forEach((participantId) => {
      if (conversation.addParticipant(participantId)) {
        addedCount++;
      }
    });

    await conversation.save();

    // Create system message
    if (addedCount > 0) {
      const systemMessage = new Message({
        conversationId,
        senderId: userId,
        content: `${req.user.fullName} added ${addedCount} member(s)`,
        messageType: "system",
        metadata: {
          systemMessageType: "user_joined",
        },
      });

      await systemMessage.save();
      conversation.lastMessage = systemMessage._id;
      await conversation.save();

      // Emit to all participants
      const io = req.app.get("io");
      conversation.getActiveParticipants().forEach((participant) => {
        io.to(`user_${participant.userId}`).emit("participants_added", {
          conversationId,
          addedParticipants: participantIds,
          systemMessage,
        });
      });
    }

    return response_handler(
      res,
      200,
      `${addedCount} participants added successfully`
    );
  } catch (error) {
    return response_handler(res, 500, "Error adding participants", {
      error: error.message,
    });
  }
};

// Remove participant from group
const removeParticipant = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId, participantId } = req.params;

    const conversation = await Conversation.findById(conversationId);
    if (!conversation) {
      return response_handler(res, 404, "Conversation not found");
    }

    // Check permissions
    if (conversation.type === "direct") {
      return response_handler(
        res,
        400,
        "Cannot remove participants from direct conversation"
      );
    }

    const isAdmin = conversation.isAdmin(userId);
    const isSelf = userId.toString() === participantId.toString();

    if (!isAdmin && !isSelf) {
      return response_handler(res, 403, "Access denied");
    }

    // Remove participant
    if (conversation.removeParticipant(participantId)) {
      await conversation.save();

      // Create system message
      const participant = await Person.findById(participantId);
      const systemMessage = new Message({
        conversationId,
        senderId: userId,
        content: isSelf
          ? `${req.user.fullName} left the group`
          : `${req.user.fullName} removed ${participant.fullName}`,
        messageType: "system",
        metadata: {
          systemMessageType: "user_left",
        },
      });

      await systemMessage.save();
      conversation.lastMessage = systemMessage._id;
      await conversation.save();

      // Emit to all participants
      const io = req.app.get("io");
      conversation.getActiveParticipants().forEach((participant) => {
        io.to(`user_${participant.userId}`).emit("participant_removed", {
          conversationId,
          removedParticipant: participantId,
          systemMessage,
        });
      });

      return response_handler(res, 200, "Participant removed successfully");
    } else {
      return response_handler(
        res,
        400,
        "Participant not found in conversation"
      );
    }
  } catch (error) {
    return response_handler(res, 500, "Error removing participant", {
      error: error.message,
    });
  }
};

// Archive/Unarchive conversation
const toggleArchiveConversation = async (req, res) => {
  try {
    const userId = req.user.id;
    const { conversationId } = req.params;

    const conversation = await Conversation.findById(conversationId);
    if (!conversation || !conversation.isParticipant(userId)) {
      return response_handler(res, 403, "Access denied to this conversation");
    }

    // Check if already archived
    const archivedIndex = conversation.archived.findIndex(
      (a) => a.userId.toString() === userId.toString()
    );

    if (archivedIndex >= 0) {
      // Unarchive
      conversation.archived.splice(archivedIndex, 1);
    } else {
      // Archive
      conversation.archived.push({
        userId,
        archivedAt: new Date(),
      });
    }

    await conversation.save();

    return response_handler(
      res,
      200,
      archivedIndex >= 0 ? "Conversation unarchived" : "Conversation archived"
    );
  } catch (error) {
    return response_handler(res, 500, "Error toggling archive status", {
      error: error.message,
    });
  }
};

module.exports = {
  getConversations,
  getOrCreateDirectConversation,
  createGroupConversation,
  getMessages,
  sendMessage,
  markMessagesAsRead,
  editMessage,
  deleteMessage,
  addParticipants,
  removeParticipant,
  toggleArchiveConversation,
};

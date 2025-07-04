const mongoose = require("mongoose");

// Schema for read receipts
const readReceiptSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Person",
      required: true,
    },
    readAt: {
      type: Date,
      default: Date.now,
    },
  },
  { _id: false }
);

// Schema for message attachments
const attachmentSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ["image", "video", "audio", "document", "location"],
      required: true,
    },
    url: {
      type: String,
      required: true,
    },
    filename: String,
    size: Number,
    mimeType: String,
    thumbnail: String, // For videos and documents
    duration: Number, // For audio/video
    location: {
      latitude: Number,
      longitude: Number,
      address: String,
    },
  },
  { _id: false }
);

// Message Schema
const messageSchema = new mongoose.Schema(
  {
    conversationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Conversation",
      required: true,
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Person",
      required: true,
    },
    content: {
      type: String,
      trim: true,
    },
    messageType: {
      type: String,
      enum: [
        "text",
        "image",
        "video",
        "audio",
        "document",
        "location",
        "system",
      ],
      default: "text",
    },
    attachments: [attachmentSchema],
    replyTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
    edited: {
      isEdited: {
        type: Boolean,
        default: false,
      },
      editedAt: Date,
      originalContent: String,
    },
    deleted: {
      isDeleted: {
        type: Boolean,
        default: false,
      },
      deletedAt: Date,
      deletedBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Person",
      },
      deletedFor: {
        type: String,
        enum: ["sender", "everyone"],
        default: "sender",
      },
    },
    readBy: [readReceiptSchema],
    deliveredTo: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Person",
        },
        deliveredAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    metadata: {
      mentions: [
        {
          userId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Person",
          },
          startIndex: Number,
          length: Number,
        },
      ],
      systemMessageType: {
        type: String,
        enum: [
          "user_joined",
          "user_left",
          "group_created",
          "group_name_changed",
          "group_photo_changed",
          "admin_added",
          "admin_removed",
        ],
      },
    },
  },
  {
    timestamps: true,
  }
);

// Conversation Schema
const conversationSchema = new mongoose.Schema(
  {
    type: {
      type: String,
      enum: ["direct", "group", "family"],
      required: true,
    },
    name: {
      type: String,
      trim: true,
    },
    description: String,
    avatar: String,
    participants: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Person",
          required: true,
        },
        role: {
          type: String,
          enum: ["admin", "member"],
          default: "member",
        },
        joinedAt: {
          type: Date,
          default: Date.now,
        },
        leftAt: Date,
        isActive: {
          type: Boolean,
          default: true,
        },
        muteUntil: Date,
        lastSeenMessageId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Message",
        },
      },
    ],
    familyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Family",
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Person",
      required: true,
    },
    lastMessage: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
    lastActivity: {
      type: Date,
      default: Date.now,
    },
    settings: {
      allowMembersToAddOthers: {
        type: Boolean,
        default: true,
      },
      onlyAdminsCanSend: {
        type: Boolean,
        default: false,
      },
      disappearingMessages: {
        enabled: {
          type: Boolean,
          default: false,
        },
        duration: {
          type: Number, // in milliseconds
          default: 604800000, // 7 days
        },
      },
    },
    archived: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Person",
        },
        archivedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    pinned: [
      {
        userId: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Person",
        },
        pinnedAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
  },
  {
    timestamps: true,
  }
);

// Indexes for better performance
messageSchema.index({ conversationId: 1, createdAt: -1 });
messageSchema.index({ senderId: 1 });
messageSchema.index({ "readBy.userId": 1 });

conversationSchema.index({ "participants.userId": 1 });
conversationSchema.index({ type: 1 });
conversationSchema.index({ familyId: 1 });
conversationSchema.index({ lastActivity: -1 });

// Instance methods for Conversation
conversationSchema.methods.addParticipant = function (userId, role = "member") {
  const existingParticipant = this.participants.find(
    (p) => p.userId.toString() === userId.toString() && p.isActive
  );

  if (existingParticipant) {
    return false; // Already a participant
  }

  this.participants.push({
    userId,
    role,
    joinedAt: new Date(),
    isActive: true,
  });

  return true;
};

conversationSchema.methods.removeParticipant = function (userId) {
  const participant = this.participants.find(
    (p) => p.userId.toString() === userId.toString() && p.isActive
  );

  if (participant) {
    participant.isActive = false;
    participant.leftAt = new Date();
    return true;
  }

  return false;
};

conversationSchema.methods.getActiveParticipants = function () {
  return this.participants.filter((p) => p.isActive);
};

conversationSchema.methods.isParticipant = function (userId) {
  return this.participants.some(
    (p) => p.userId.toString() === userId.toString() && p.isActive
  );
};

conversationSchema.methods.isAdmin = function (userId) {
  const participant = this.participants.find(
    (p) => p.userId.toString() === userId.toString() && p.isActive
  );
  return participant && participant.role === "admin";
};

// Instance methods for Message
messageSchema.methods.markAsRead = function (userId) {
  const existingRead = this.readBy.find(
    (r) => r.userId.toString() === userId.toString()
  );

  if (!existingRead) {
    this.readBy.push({
      userId,
      readAt: new Date(),
    });
    return true;
  }

  return false;
};

messageSchema.methods.markAsDelivered = function (userId) {
  const existingDelivery = this.deliveredTo.find(
    (d) => d.userId.toString() === userId.toString()
  );

  if (!existingDelivery) {
    this.deliveredTo.push({
      userId,
      deliveredAt: new Date(),
    });
    return true;
  }

  return false;
};

messageSchema.methods.isReadBy = function (userId) {
  return this.readBy.some((r) => r.userId.toString() === userId.toString());
};

messageSchema.methods.isDeliveredTo = function (userId) {
  return this.deliveredTo.some(
    (d) => d.userId.toString() === userId.toString()
  );
};

// Virtual for unread count per user (to be used in aggregation)
conversationSchema.virtual("unreadCount").get(function () {
  return 0; // This will be calculated in the controller
});

const Conversation = mongoose.model("Conversation", conversationSchema);
const Message = mongoose.model("Message", messageSchema);

module.exports = {
  Conversation,
  Message,
};

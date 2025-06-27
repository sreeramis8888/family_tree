const Joi = require("joi");
const response_handler = require("../../helpers/responseHandler");

// Validate message sending
const sendMessage = (req, res, next) => {
  const schema = Joi.object({
    content: Joi.string()
      .min(1)
      .max(4000)
      .when("messageType", {
        is: "text",
        then: Joi.required(),
        otherwise: Joi.optional(),
      })
      .messages({
        "string.min": "Message content cannot be empty",
        "string.max": "Message content cannot exceed 4000 characters",
        "any.required": "Message content is required for text messages",
      }),
    messageType: Joi.string()
      .valid("text", "image", "video", "audio", "document", "location")
      .default("text")
      .messages({
        "any.only": "Invalid message type",
      }),
    attachments: Joi.array()
      .items(
        Joi.object({
          type: Joi.string()
            .valid("image", "video", "audio", "document", "location")
            .required(),
          url: Joi.string().uri().required(),
          filename: Joi.string().optional(),
          size: Joi.number().positive().optional(),
          mimeType: Joi.string().optional(),
          thumbnail: Joi.string().uri().optional(),
          duration: Joi.number().positive().optional(),
          location: Joi.object({
            latitude: Joi.number().min(-90).max(90).required(),
            longitude: Joi.number().min(-180).max(180).required(),
            address: Joi.string().optional(),
          }).optional(),
        })
      )
      .optional()
      .messages({
        "array.base": "Attachments must be an array",
      }),
    replyTo: Joi.string()
      .pattern(/^[0-9a-fA-F]{24}$/)
      .optional()
      .messages({
        "string.pattern.base": "Invalid reply message ID format",
      }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate group conversation creation
const createGroupConversation = (req, res, next) => {
  const schema = Joi.object({
    name: Joi.string().min(1).max(100).required().messages({
      "string.min": "Group name cannot be empty",
      "string.max": "Group name cannot exceed 100 characters",
      "any.required": "Group name is required",
    }),
    description: Joi.string().max(500).optional().messages({
      "string.max": "Description cannot exceed 500 characters",
    }),
    participantIds: Joi.array()
      .items(
        Joi.string()
          .pattern(/^[0-9a-fA-F]{24}$/)
          .messages({
            "string.pattern.base": "Invalid participant ID format",
          })
      )
      .min(1)
      .max(200)
      .required()
      .messages({
        "array.min": "At least one participant is required",
        "array.max": "Cannot have more than 200 participants",
        "any.required": "Participants list is required",
      }),
    familyId: Joi.string()
      .pattern(/^[0-9a-fA-F]{24}$/)
      .optional()
      .messages({
        "string.pattern.base": "Invalid family ID format",
      }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate marking messages as read
const markMessagesAsRead = (req, res, next) => {
  const schema = Joi.object({
    messageIds: Joi.array()
      .items(
        Joi.string()
          .pattern(/^[0-9a-fA-F]{24}$/)
          .messages({
            "string.pattern.base": "Invalid message ID format",
          })
      )
      .min(1)
      .max(100)
      .required()
      .messages({
        "array.min": "At least one message ID is required",
        "array.max": "Cannot mark more than 100 messages at once",
        "any.required": "Message IDs are required",
      }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate message editing
const editMessage = (req, res, next) => {
  const schema = Joi.object({
    content: Joi.string().min(1).max(4000).required().messages({
      "string.min": "Message content cannot be empty",
      "string.max": "Message content cannot exceed 4000 characters",
      "any.required": "Message content is required",
    }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate message deletion
const deleteMessage = (req, res, next) => {
  const schema = Joi.object({
    deleteFor: Joi.string()
      .valid("sender", "everyone")
      .default("sender")
      .messages({
        "any.only": "Delete for must be either 'sender' or 'everyone'",
      }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate adding participants to group
const addParticipants = (req, res, next) => {
  const schema = Joi.object({
    participantIds: Joi.array()
      .items(
        Joi.string()
          .pattern(/^[0-9a-fA-F]{24}$/)
          .messages({
            "string.pattern.base": "Invalid participant ID format",
          })
      )
      .min(1)
      .max(50)
      .required()
      .messages({
        "array.min": "At least one participant is required",
        "array.max": "Cannot add more than 50 participants at once",
        "any.required": "Participants list is required",
      }),
  });

  const { error } = schema.validate(req.body);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate conversation parameters (for routes with conversationId)
const validateConversationId = (req, res, next) => {
  const conversationId = req.params.conversationId;

  if (!conversationId) {
    return response_handler(res, 400, "Conversation ID is required", null);
  }

  if (!/^[0-9a-fA-F]{24}$/.test(conversationId)) {
    return response_handler(res, 400, "Invalid conversation ID format", null);
  }

  next();
};

// Validate message parameters (for routes with messageId)
const validateMessageId = (req, res, next) => {
  const messageId = req.params.messageId;

  if (!messageId) {
    return response_handler(res, 400, "Message ID is required", null);
  }

  if (!/^[0-9a-fA-F]{24}$/.test(messageId)) {
    return response_handler(res, 400, "Invalid message ID format", null);
  }

  next();
};

// Validate pagination parameters
const validatePagination = (req, res, next) => {
  const schema = Joi.object({
    page: Joi.number().integer().min(1).default(1).messages({
      "number.base": "Page must be a number",
      "number.integer": "Page must be an integer",
      "number.min": "Page must be at least 1",
    }),
    limit: Joi.number().integer().min(1).max(100).default(20).messages({
      "number.base": "Limit must be a number",
      "number.integer": "Limit must be an integer",
      "number.min": "Limit must be at least 1",
      "number.max": "Limit cannot exceed 100",
    }),
    search: Joi.string().max(100).optional().messages({
      "string.max": "Search term cannot exceed 100 characters",
    }),
    type: Joi.string().valid("direct", "group", "family").optional().messages({
      "any.only": "Invalid conversation type",
    }),
  });

  const { error } = schema.validate(req.query);
  if (error) {
    return response_handler(res, 400, error.details[0].message, null);
  }
  next();
};

// Validate recipient ID for direct conversation
const validateRecipientId = (req, res, next) => {
  const recipientId = req.params.recipientId;

  if (!recipientId) {
    return response_handler(res, 400, "Recipient ID is required", null);
  }

  if (!/^[0-9a-fA-F]{24}$/.test(recipientId)) {
    return response_handler(res, 400, "Invalid recipient ID format", null);
  }

  next();
};

// Validate participant ID for participant management
const validateParticipantId = (req, res, next) => {
  const participantId = req.params.participantId;

  if (!participantId) {
    return response_handler(res, 400, "Participant ID is required", null);
  }

  if (!/^[0-9a-fA-F]{24}$/.test(participantId)) {
    return response_handler(res, 400, "Invalid participant ID format", null);
  }

  next();
};

module.exports = {
  sendMessage,
  createGroupConversation,
  markMessagesAsRead,
  editMessage,
  deleteMessage,
  addParticipants,
  validateConversationId,
  validateMessageId,
  validatePagination,
  validateRecipientId,
  validateParticipantId,
};

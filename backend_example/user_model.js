// Modèle utilisateur MongoDB pour Safari Smart Mobility
// Mongoose Schema

const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  // Identifiants
  firebaseUid: {
    type: String,
    unique: true,
    sparse: true, // Permet les valeurs null
    index: true
  },
  
  // Informations personnelles
  name: {
    type: String,
    required: true,
    trim: true,
    maxlength: 100
  },
  
  phone: {
    type: String,
    required: true,
    unique: true,
    index: true,
    match: /^\+[1-9]\d{1,14}$/ // Format international
  },
  
  email: {
    type: String,
    sparse: true, // Permet les valeurs null
    lowercase: true,
    trim: true,
    match: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  },
  
  password: {
    type: String,
    minlength: 6
  },
  
  // Rôle et permissions
  role: {
    type: String,
    enum: ['passenger', 'driver', 'controller', 'collector', 'admin'],
    default: 'passenger'
  },
  
  // Statut de vérification
  isVerified: {
    type: Boolean,
    default: false
  },
  
  isActive: {
    type: Boolean,
    default: true
  },
  
  // Informations de transport
  travelPurpose: {
    type: String,
    enum: ['work', 'study', 'leisure', 'business', 'other'],
    default: 'work'
  },
  
  // Paramètres financiers
  balance: {
    type: Number,
    default: 0,
    min: 0
  },
  
  autoRecharge: {
    type: Boolean,
    default: false
  },
  
  autoRechargeAmount: {
    type: Number,
    default: 1000,
    min: 500
  },
  
  autoRechargeThreshold: {
    type: Number,
    default: 200,
    min: 0
  },
  
  // Gamification
  badges: [{
    name: String,
    earnedAt: {
      type: Date,
      default: Date.now
    },
    description: String
  }],
  
  totalTrips: {
    type: Number,
    default: 0
  },
  
  totalDistance: {
    type: Number,
    default: 0
  },
  
  loyaltyPoints: {
    type: Number,
    default: 0
  },
  
  // Préférences utilisateur
  preferences: {
    language: {
      type: String,
      enum: ['fr', 'en'],
      default: 'fr'
    },
    
    notifications: {
      sms: {
        type: Boolean,
        default: true
      },
      email: {
        type: Boolean,
        default: false
      },
      push: {
        type: Boolean,
        default: true
      }
    },
    
    theme: {
      type: String,
      enum: ['light', 'dark', 'auto'],
      default: 'light'
    }
  },
  
  // Informations de localisation (optionnel)
  location: {
    city: String,
    district: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  
  // Informations de connexion
  lastLoginAt: Date,
  
  loginCount: {
    type: Number,
    default: 0
  },
  
  // Informations de sécurité
  failedLoginAttempts: {
    type: Number,
    default: 0
  },
  
  lockedUntil: Date,
  
  // Métadonnées
  createdAt: {
    type: Date,
    default: Date.now
  },
  
  updatedAt: {
    type: Date,
    default: Date.now
  },
  
  // Informations de l'appareil (pour les notifications push)
  deviceTokens: [{
    token: String,
    platform: {
      type: String,
      enum: ['android', 'ios']
    },
    addedAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true, // Ajoute automatiquement createdAt et updatedAt
  collection: 'users'
});

// Index composés pour les requêtes fréquentes
userSchema.index({ phone: 1, isActive: 1 });
userSchema.index({ firebaseUid: 1, isActive: 1 });
userSchema.index({ role: 1, isActive: 1 });
userSchema.index({ createdAt: -1 });

// Middleware pre-save pour mettre à jour updatedAt
userSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

// Méthodes d'instance
userSchema.methods.addBadge = function(badgeName, description) {
  // Vérifier si le badge existe déjà
  const existingBadge = this.badges.find(badge => badge.name === badgeName);
  if (!existingBadge) {
    this.badges.push({
      name: badgeName,
      description: description,
      earnedAt: new Date()
    });
    return this.save();
  }
  return Promise.resolve(this);
};

userSchema.methods.updateBalance = function(amount) {
  this.balance = Math.max(0, this.balance + amount);
  return this.save();
};

userSchema.methods.incrementTrips = function() {
  this.totalTrips += 1;
  this.loyaltyPoints += 10; // 10 points par trajet
  return this.save();
};

userSchema.methods.addDeviceToken = function(token, platform) {
  // Supprimer l'ancien token s'il existe
  this.deviceTokens = this.deviceTokens.filter(dt => dt.token !== token);
  
  // Ajouter le nouveau token
  this.deviceTokens.push({
    token: token,
    platform: platform,
    addedAt: new Date()
  });
  
  // Garder seulement les 5 derniers tokens
  if (this.deviceTokens.length > 5) {
    this.deviceTokens = this.deviceTokens.slice(-5);
  }
  
  return this.save();
};

// Méthodes statiques
userSchema.statics.findByPhone = function(phone) {
  return this.findOne({ phone: phone, isActive: true });
};

userSchema.statics.findByFirebaseUid = function(firebaseUid) {
  return this.findOne({ firebaseUid: firebaseUid, isActive: true });
};

userSchema.statics.getActivePassengers = function() {
  return this.find({ role: 'passenger', isActive: true });
};

userSchema.statics.getTopUsers = function(limit = 10) {
  return this.find({ isActive: true })
    .sort({ loyaltyPoints: -1, totalTrips: -1 })
    .limit(limit);
};

// Virtuals
userSchema.virtual('isLocked').get(function() {
  return this.lockedUntil && this.lockedUntil > new Date();
});

userSchema.virtual('fullProfile').get(function() {
  return {
    id: this._id,
    name: this.name,
    phone: this.phone,
    email: this.email,
    role: this.role,
    balance: this.balance,
    badges: this.badges,
    totalTrips: this.totalTrips,
    loyaltyPoints: this.loyaltyPoints,
    isVerified: this.isVerified,
    preferences: this.preferences,
    createdAt: this.createdAt
  };
});

// Transformer pour exclure les champs sensibles lors de la sérialisation
userSchema.methods.toJSON = function() {
  const user = this.toObject();
  delete user.password;
  delete user.failedLoginAttempts;
  delete user.lockedUntil;
  delete user.deviceTokens;
  delete user.__v;
  return user;
};

module.exports = mongoose.model('User', userSchema);

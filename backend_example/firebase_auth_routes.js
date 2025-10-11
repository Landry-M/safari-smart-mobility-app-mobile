// Firebase Auth Routes pour Safari Smart Mobility Backend
// Node.js/Express avec Firebase Admin SDK

const express = require('express');
const admin = require('firebase-admin');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const router = express.Router();

// Initialiser Firebase Admin (à faire une seule fois dans app.js)
/*
const serviceAccount = require('./path/to/serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'safari-smart-mobility'
});
*/

// Modèle utilisateur (exemple avec MongoDB/Mongoose)
const User = require('../models/User');

/**
 * Vérifier le token Firebase et authentifier l'utilisateur
 * POST /auth/verify-firebase
 */
router.post('/verify-firebase', async (req, res) => {
  try {
    const { idToken, phoneNumber } = req.body;

    if (!idToken) {
      return res.status(400).json({
        success: false,
        message: 'Token Firebase requis'
      });
    }

    // Vérifier le token Firebase
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    const firebaseUid = decodedToken.uid;
    const firebasePhone = decodedToken.phone_number;

    console.log('Firebase token vérifié pour UID:', firebaseUid);

    // Chercher l'utilisateur existant
    let user = await User.findOne({ 
      $or: [
        { firebaseUid: firebaseUid },
        { phone: firebasePhone || phoneNumber }
      ]
    });

    if (user) {
      // Utilisateur existant - mettre à jour le Firebase UID si nécessaire
      if (!user.firebaseUid) {
        user.firebaseUid = firebaseUid;
        await user.save();
      }
    } else {
      // Nouvel utilisateur - créer un compte basique
      user = new User({
        firebaseUid: firebaseUid,
        phone: firebasePhone || phoneNumber,
        name: 'Utilisateur Safari', // Nom par défaut
        email: null,
        role: 'passenger',
        isVerified: true, // Vérifié via Firebase
        balance: 0,
        badges: [],
        createdAt: new Date()
      });
      await user.save();
      console.log('Nouvel utilisateur créé:', user._id);
    }

    // Générer JWT token pour l'application
    const appToken = jwt.sign(
      { 
        userId: user._id,
        firebaseUid: firebaseUid,
        phone: user.phone,
        role: user.role
      },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    // Réponse de succès
    res.json({
      success: true,
      message: 'Authentification réussie',
      user: {
        id: user._id,
        firebaseUid: user.firebaseUid,
        name: user.name,
        phone: user.phone,
        email: user.email,
        role: user.role,
        balance: user.balance,
        badges: user.badges,
        isVerified: user.isVerified
      },
      token: appToken
    });

  } catch (error) {
    console.error('Erreur vérification Firebase:', error);
    
    if (error.code === 'auth/id-token-expired') {
      return res.status(401).json({
        success: false,
        message: 'Token expiré'
      });
    }
    
    if (error.code === 'auth/invalid-id-token') {
      return res.status(401).json({
        success: false,
        message: 'Token invalide'
      });
    }

    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de la vérification'
    });
  }
});

/**
 * Inscription utilisateur avec données complètes
 * POST /auth/register
 */
router.post('/register', async (req, res) => {
  try {
    const { name, phone, email, password, travelPurpose, autoRecharge } = req.body;

    // Validation
    if (!name || !phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Nom, téléphone et mot de passe requis'
      });
    }

    // Vérifier si l'utilisateur existe déjà
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Un compte existe déjà avec ce numéro'
      });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    // Créer l'utilisateur
    const user = new User({
      name,
      phone,
      email: email || null,
      password: hashedPassword,
      role: 'passenger',
      travelPurpose: travelPurpose || 'work',
      autoRecharge: autoRecharge || false,
      balance: 0,
      badges: [],
      isVerified: false, // Sera vérifié via Firebase OTP
      createdAt: new Date()
    });

    await user.save();

    res.json({
      success: true,
      message: 'Compte créé avec succès. Vérifiez votre téléphone.',
      userId: user._id
    });

  } catch (error) {
    console.error('Erreur inscription:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de l\'inscription'
    });
  }
});

/**
 * Connexion traditionnelle (email/mot de passe)
 * POST /auth/login
 */
router.post('/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Téléphone et mot de passe requis'
      });
    }

    // Chercher l'utilisateur
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Identifiants incorrects'
      });
    }

    // Vérifier le mot de passe
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({
        success: false,
        message: 'Identifiants incorrects'
      });
    }

    // Générer le token
    const token = jwt.sign(
      { 
        userId: user._id,
        phone: user.phone,
        role: user.role
      },
      process.env.JWT_SECRET,
      { expiresIn: '30d' }
    );

    res.json({
      success: true,
      message: 'Connexion réussie',
      user: {
        id: user._id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        role: user.role,
        balance: user.balance,
        badges: user.badges,
        isVerified: user.isVerified
      },
      token
    });

  } catch (error) {
    console.error('Erreur connexion:', error);
    res.status(500).json({
      success: false,
      message: 'Erreur serveur lors de la connexion'
    });
  }
});

/**
 * Middleware d'authentification
 */
const authenticateToken = async (req, res, next) => {
  try {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token d\'accès requis'
      });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId);
    
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Utilisateur non trouvé'
      });
    }

    req.user = user;
    next();
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: 'Token invalide'
    });
  }
};

/**
 * Obtenir le profil utilisateur
 * GET /auth/profile
 */
router.get('/profile', authenticateToken, async (req, res) => {
  try {
    res.json({
      success: true,
      user: {
        id: req.user._id,
        name: req.user.name,
        phone: req.user.phone,
        email: req.user.email,
        role: req.user.role,
        balance: req.user.balance,
        badges: req.user.badges,
        isVerified: req.user.isVerified,
        travelPurpose: req.user.travelPurpose,
        autoRecharge: req.user.autoRecharge
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Erreur serveur'
    });
  }
});

/**
 * Déconnexion
 * POST /auth/logout
 */
router.post('/logout', authenticateToken, async (req, res) => {
  try {
    // Dans une vraie app, vous pourriez blacklister le token
    // ou le stocker dans Redis avec une expiration
    
    res.json({
      success: true,
      message: 'Déconnexion réussie'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Erreur serveur'
    });
  }
});

module.exports = router;

import 'package:flutter/material.dart';

class EmotionEntity {
  final String name;
  final Color color;
  final String description;

  const EmotionEntity({
    required this.name,
    required this.color,
    required this.description,
  });
}

// --- Color constants ---
const cPeach = Color(0xFFFFCBA4);
const cSlate = Color(0xFF708090);
const cTeal = Color(0xFF008080);
const cSky = Color(0xFF87CEEB);

// --- Seed list ---
class SeedEmotions {
  static const List<EmotionEntity> list = [
    // Group 1: Positive 😀 (cPeach)
    EmotionEntity(name: "Serenity", color: cPeach, description: "Inner calm and peace"),
    EmotionEntity(name: "Joy", color: cPeach, description: "Moderate happiness"),
    EmotionEntity(name: "Ecstasy", color: cPeach, description: "Intense happiness"),
    EmotionEntity(name: "Acceptance", color: cPeach, description: "Openness, tolerance"),
    EmotionEntity(name: "Trust", color: cPeach, description: "Feeling of security"),
    EmotionEntity(name: "Admiration", color: cPeach, description: "Positive recognition"),
    EmotionEntity(name: "Love", color: cPeach, description: "Joy + Trust"),
    EmotionEntity(name: "Optimism", color: cPeach, description: "Joy + Anticipation"),
    EmotionEntity(name: "Hope", color: cPeach, description: "Trust + Anticipation"),
    EmotionEntity(name: "Pride", color: cPeach, description: "Joy + Anger"),
    EmotionEntity(name: "Gratitude", color: cPeach, description: "Joy + Surprise"),
    EmotionEntity(name: "Affection", color: cPeach, description: "Warmth and care"),

    // Group 2: Negative Introspective 😢 (cSlate)
    EmotionEntity(name: "Pensiveness", color: cSlate, description: "Mild sadness"),
    EmotionEntity(name: "Sadness", color: cSlate, description: "Loss or discouragement"),
    EmotionEntity(name: "Grief", color: cSlate, description: "Deep sadness"),
    EmotionEntity(name: "Apprehension", color: cSlate, description: "Mild fear"),
    EmotionEntity(name: "Fear", color: cSlate, description: "Perceived threat"),
    EmotionEntity(name: "Terror", color: cSlate, description: "Extreme fear"),
    EmotionEntity(name: "Despair", color: cSlate, description: "Sadness + Anticipation"),
    EmotionEntity(name: "Insecurity", color: cSlate, description: "Sadness + Trust"),
    EmotionEntity(name: "Guilt", color: cSlate, description: "Joy + Sadness"),
    EmotionEntity(name: "Submission", color: cSlate, description: "Fear + Trust"),
    EmotionEntity(name: "Self-rejection", color: cSlate, description: "Aversion toward self"),
    EmotionEntity(name: "Helplessness", color: cSlate, description: "Sense of powerlessness"),

    // Group 3: Negative Reactive 😡 (cTeal)
    EmotionEntity(name: "Annoyance", color: cTeal, description: "Mild anger"),
    EmotionEntity(name: "Anger", color: cTeal, description: "Moderate rage"),
    EmotionEntity(name: "Rage", color: cTeal, description: "Intense anger"),
    EmotionEntity(name: "Boredom", color: cTeal, description: "Lack of interest"),
    EmotionEntity(name: "Disgust", color: cTeal, description: "Moderate revulsion"),
    EmotionEntity(name: "Loathing", color: cTeal, description: "Intense disgust"),
    EmotionEntity(name: "Contempt", color: cTeal, description: "Anger + Disgust"),
    EmotionEntity(name: "Aggressiveness", color: cTeal, description: "Anger + Anticipation"),
    EmotionEntity(name: "Envy", color: cTeal, description: "Anger + Sadness"),
    EmotionEntity(name: "Remorse", color: cTeal, description: "Disgust + Sadness"),
    EmotionEntity(name: "Cynicism", color: cTeal, description: "Distrust with irony"),
    EmotionEntity(name: "Revenge", color: cTeal, description: "Desire for retaliation"),

    // Group 4: Dynamic / Cognitive 😲 (cSky)
    EmotionEntity(name: "Distraction", color: cSky, description: "Mild surprise"),
    EmotionEntity(name: "Surprise", color: cSky, description: "Unexpected reaction"),
    EmotionEntity(name: "Amazement", color: cSky, description: "Intense surprise"),
    EmotionEntity(name: "Interest", color: cSky, description: "Moderate curiosity"),
    EmotionEntity(name: "Anticipation", color: cSky, description: "Expectation of something"),
    EmotionEntity(name: "Vigilance", color: cSky, description: "Extreme anticipation"),
    EmotionEntity(name: "Curiosity", color: cSky, description: "Surprise + Anticipation"),
    EmotionEntity(name: "Anxiety", color: cSky, description: "Fear + Anticipation"),
    EmotionEntity(name: "Startle", color: cSky, description: "Fear + Surprise"),
    EmotionEntity(name: "Confusion", color: cSky, description: "Surprise + Sadness"),
    EmotionEntity(name: "Fascination", color: cSky, description: "Surprise + Joy"),
    EmotionEntity(name: "Expectation", color: cSky, description: "Directed anticipation"),
  ];
}

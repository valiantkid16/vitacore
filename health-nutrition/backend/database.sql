-- ============================================================
-- VITACORE – Complete MySQL Database Schema v2.0
-- D.NO: 23UCS553 | Kiran Kumar K.R | BSc CS "A"
-- Guide: Dr. B. REX CYRIL
-- ============================================================

CREATE DATABASE IF NOT EXISTS vitacore_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vitacore_db;

-- 1. USERS
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name  VARCHAR(100) NOT NULL,
  email      VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role       ENUM('user','nutritionist','admin') DEFAULT 'user',
  phone      VARCHAR(20),
  date_of_birth DATE,
  gender     ENUM('male','female','other'),
  is_active  BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. USER HEALTH PROFILES
CREATE TABLE user_health_profiles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL UNIQUE,
  height_cm  DECIMAL(5,2),
  weight_kg  DECIMAL(5,2),
  target_weight_kg DECIMAL(5,2),
  activity_level ENUM('sedentary','lightly_active','moderately_active','very_active','extra_active') DEFAULT 'moderately_active',
  health_goal ENUM('weight_loss','weight_gain','maintenance','muscle_gain','diabetic_care','heart_health') DEFAULT 'maintenance',
  daily_calorie_goal  INT DEFAULT 2000,
  daily_protein_goal_g INT DEFAULT 150,
  daily_carbs_goal_g   INT DEFAULT 250,
  daily_fat_goal_g     INT DEFAULT 65,
  daily_water_goal_l   DECIMAL(3,1) DEFAULT 2.5,
  daily_sleep_goal_h   DECIMAL(3,1) DEFAULT 8.0,
  daily_workout_goal_min INT DEFAULT 60,
  medical_conditions TEXT,
  allergies TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. FOOD ITEMS
CREATE TABLE food_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(255) NOT NULL,
  brand      VARCHAR(100),
  category   ENUM('fruit','vegetable','grain','protein','dairy','fat','beverage','snack','meal','supplement','other') DEFAULT 'other',
  serving_size_g       DECIMAL(7,2) DEFAULT 100,
  serving_description  VARCHAR(100) DEFAULT '100g',
  calories_kcal        DECIMAL(7,2) NOT NULL DEFAULT 0,
  protein_g            DECIMAL(7,2) DEFAULT 0,
  carbohydrates_g      DECIMAL(7,2) DEFAULT 0,
  fat_g                DECIMAL(7,2) DEFAULT 0,
  fiber_g              DECIMAL(7,2) DEFAULT 0,
  sugar_g              DECIMAL(7,2) DEFAULT 0,
  sodium_mg            DECIMAL(7,2) DEFAULT 0,
  calcium_mg           DECIMAL(7,2) DEFAULT 0,
  iron_mg              DECIMAL(7,2) DEFAULT 0,
  vitamin_c_mg         DECIMAL(7,2) DEFAULT 0,
  vitamin_d_iu         DECIMAL(7,2) DEFAULT 0,
  potassium_mg         DECIMAL(7,2) DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  created_by  INT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_food_name (name),
  INDEX idx_food_category (category)
);

-- 4. MEAL LOGS
CREATE TABLE meal_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT NOT NULL,
  food_item_id INT NOT NULL,
  meal_type    ENUM('breakfast','lunch','dinner','snack','pre_workout','post_workout') NOT NULL,
  log_date     DATE NOT NULL,
  log_time     TIME DEFAULT '12:00:00',
  quantity_g   DECIMAL(7,2) DEFAULT 100,
  calories_kcal      DECIMAL(7,2) NOT NULL,
  protein_g          DECIMAL(7,2) DEFAULT 0,
  carbohydrates_g    DECIMAL(7,2) DEFAULT 0,
  fat_g              DECIMAL(7,2) DEFAULT 0,
  notes VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE,
  INDEX idx_meal_user_date (user_id, log_date)
);

-- 5. WORKOUT TYPES
CREATE TABLE workout_types (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  category    ENUM('cardio','strength','flexibility','balance','sports','other') DEFAULT 'other',
  description TEXT,
  met_value   DECIMAL(4,2) DEFAULT 4.0
);

-- 6. WORKOUT LOGS
CREATE TABLE workout_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT NOT NULL,
  workout_type_id  INT,
  workout_name     VARCHAR(200),
  log_date         DATE NOT NULL,
  start_time       TIME,
  duration_minutes INT NOT NULL,
  intensity        ENUM('low','medium','high') DEFAULT 'medium',
  calories_burned  DECIMAL(7,2),
  distance_km      DECIMAL(7,2),
  sets             INT,
  reps             INT,
  weight_lifted_kg DECIMAL(7,2),
  heart_rate_avg   INT,
  heart_rate_max   INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (workout_type_id) REFERENCES workout_types(id) ON DELETE SET NULL,
  INDEX idx_workout_user_date (user_id, log_date)
);

-- 7. WATER LOGS
CREATE TABLE water_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  log_date   DATE NOT NULL,
  log_time   TIME DEFAULT CURRENT_TIME,
  amount_ml  INT NOT NULL DEFAULT 250,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_water_user_date (user_id, log_date)
);

-- 8. SLEEP LOGS
CREATE TABLE sleep_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id          INT NOT NULL,
  sleep_date       DATE NOT NULL,
  bedtime          TIME,
  wake_time        TIME,
  duration_hours   DECIMAL(4,2),
  quality          ENUM('poor','fair','good','excellent') DEFAULT 'good',
  deep_sleep_min   INT,
  rem_sleep_min    INT,
  awake_times      INT DEFAULT 0,
  notes VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_sleep_user_date (user_id, sleep_date)
);

-- 9. HEALTH METRICS (Weight, BMI, Blood Pressure, etc.)
CREATE TABLE health_metrics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id              INT NOT NULL,
  metric_date          DATE NOT NULL,
  weight_kg            DECIMAL(5,2),
  bmi                  DECIMAL(4,2),
  body_fat_percentage  DECIMAL(4,2),
  muscle_mass_kg       DECIMAL(5,2),
  waist_cm             DECIMAL(5,2),
  chest_cm             DECIMAL(5,2),
  hips_cm              DECIMAL(5,2),
  systolic_bp          INT,
  diastolic_bp         INT,
  heart_rate_resting   INT,
  blood_glucose_mg_dl  DECIMAL(6,2),
  cholesterol_mg_dl    DECIMAL(6,2),
  notes TEXT,
  recorded_by ENUM('self','nutritionist','doctor') DEFAULT 'self',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_metrics_user_date (user_id, metric_date)
);

-- 10. MEAL PLANS
CREATE TABLE meal_plans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id           INT NOT NULL,
  nutritionist_id   INT,
  title             VARCHAR(200) NOT NULL,
  description       TEXT,
  start_date        DATE,
  end_date          DATE,
  daily_calorie_target INT,
  goal ENUM('weight_loss','weight_gain','maintenance','muscle_gain','diabetic_care') DEFAULT 'maintenance',
  is_active BOOLEAN DEFAULT TRUE,
  is_ai_generated BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (nutritionist_id) REFERENCES users(id) ON DELETE SET NULL
);

-- 11. MEAL PLAN ITEMS
CREATE TABLE meal_plan_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  meal_plan_id INT NOT NULL,
  food_item_id INT NOT NULL,
  day_number   INT NOT NULL,
  meal_type    ENUM('breakfast','lunch','dinner','snack','pre_workout','post_workout') NOT NULL,
  quantity_g   DECIMAL(7,2) DEFAULT 100,
  notes VARCHAR(300),
  FOREIGN KEY (meal_plan_id) REFERENCES meal_plans(id) ON DELETE CASCADE,
  FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

-- 12. CONSULTATIONS
CREATE TABLE consultations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id           INT NOT NULL,
  nutritionist_id   INT NOT NULL,
  scheduled_at      DATETIME NOT NULL,
  duration_minutes  INT DEFAULT 30,
  session_type      ENUM('video','phone','chat') DEFAULT 'video',
  status            ENUM('pending','confirmed','completed','cancelled') DEFAULT 'pending',
  meeting_link      VARCHAR(500),
  topic             VARCHAR(500),
  notes             TEXT,
  feedback          TEXT,
  rating            TINYINT CHECK (rating BETWEEN 1 AND 5),
  fee_amount        DECIMAL(8,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (nutritionist_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 13. NOTIFICATIONS
CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  type       ENUM('water_reminder','meal_reminder','workout_reminder','sleep_reminder','goal_achieved','consultation','alert','system') DEFAULT 'system',
  title      VARCHAR(200) NOT NULL,
  message    TEXT,
  is_read    BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_notif_user (user_id, is_read)
);

-- 14. USER ACTIVE STREAKS
CREATE TABLE user_streaks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id        INT NOT NULL UNIQUE,
  current_streak INT DEFAULT 0,
  best_streak    INT DEFAULT 0,
  last_active    DATE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ============================================================
-- SEED DATA
-- ============================================================

INSERT INTO users (first_name, last_name, email, password_hash, role) VALUES
('Admin', 'VitaCore', 'admin@vitacore.app', '$2b$12$placeholder_admin_hash', 'admin'),
('Kiran', 'Kumar', 'kiran@vitacore.app', '$2b$12$placeholder_user_hash', 'user'),
('Dr. Sarah', 'Johnson', 'sarah@vitacore.app', '$2b$12$placeholder_nutritionist_hash', 'nutritionist'),
('Dr. Raj', 'Patel', 'raj@vitacore.app', '$2b$12$placeholder_nutritionist2_hash', 'nutritionist');

INSERT INTO user_health_profiles (user_id, height_cm, weight_kg, target_weight_kg, activity_level, health_goal, daily_calorie_goal, daily_protein_goal_g, daily_carbs_goal_g, daily_fat_goal_g, daily_water_goal_l)
VALUES (2, 174, 72, 68, 'moderately_active', 'weight_loss', 2400, 180, 300, 70, 2.5);

INSERT INTO food_items (name, category, serving_size_g, serving_description, calories_kcal, protein_g, carbohydrates_g, fat_g, fiber_g, is_verified) VALUES
('Grilled Chicken Breast', 'protein', 100, '100g cooked', 165, 31, 0, 3.6, 0, TRUE),
('Brown Rice', 'grain', 195, '1 cup cooked', 216, 5, 45, 1.8, 3.5, TRUE),
('Broccoli', 'vegetable', 100, '100g raw', 55, 3.7, 11, 0.6, 2.6, TRUE),
('Banana', 'fruit', 118, '1 medium', 89, 1.1, 23, 0.3, 2.6, TRUE),
('Greek Yogurt', 'dairy', 200, '200g serving', 130, 17, 9, 3.5, 0, TRUE),
('Oats', 'grain', 100, '100g dry', 389, 17, 66, 7, 11, TRUE),
('Atlantic Salmon', 'protein', 150, '150g fillet', 280, 39, 0, 13, 0, TRUE),
('Almonds', 'fat', 30, '30g (~23 nuts)', 173, 6, 6, 15, 3.5, TRUE),
('Sweet Potato', 'vegetable', 130, '1 medium', 103, 2.3, 24, 0.1, 3.8, TRUE),
('Whole Egg', 'protein', 50, '1 large egg', 72, 6, 0.4, 5, 0, TRUE),
('Spinach', 'vegetable', 100, '100g raw', 23, 2.9, 3.6, 0.4, 2.2, TRUE),
('Avocado', 'fat', 150, '1 medium', 234, 3, 12, 21, 9.8, TRUE),
('Whole Wheat Bread', 'grain', 30, '1 slice', 81, 4, 15, 1, 1.9, TRUE),
('Milk (2%)', 'dairy', 240, '1 cup', 122, 8, 12, 4.8, 0, TRUE),
('Lentils', 'protein', 198, '1 cup cooked', 230, 18, 40, 0.8, 15.6, TRUE),
('Quinoa', 'grain', 185, '1 cup cooked', 222, 8, 39, 3.5, 5, TRUE),
('Cottage Cheese', 'dairy', 100, '100g', 98, 11, 3.4, 4.3, 0, TRUE),
('Blueberries', 'fruit', 100, '100g', 57, 0.7, 14, 0.3, 2.4, TRUE),
('Peanut Butter', 'fat', 32, '2 tbsp', 188, 8, 6, 16, 1.9, TRUE),
('Tuna (canned)', 'protein', 100, '100g drained', 116, 26, 0, 0.5, 0, TRUE);

INSERT INTO workout_types (name, category, description, met_value) VALUES
('Running', 'cardio', 'Outdoor or treadmill running', 9.8),
('Cycling', 'cardio', 'Stationary or outdoor cycling', 7.5),
('Swimming', 'cardio', 'Freestyle or mixed strokes', 8.0),
('Upper Body Strength', 'strength', 'Chest, back, shoulders, arms', 5.0),
('Lower Body Strength', 'strength', 'Quads, hamstrings, glutes', 5.5),
('Full Body Strength', 'strength', 'Compound movements', 5.5),
('Yoga', 'flexibility', 'Hatha, vinyasa, or yin yoga', 3.0),
('HIIT', 'cardio', 'High-Intensity Interval Training', 11.0),
('Walking', 'cardio', 'Brisk walking', 3.5),
('Pilates', 'flexibility', 'Core-focused mat work', 3.8);

INSERT INTO user_streaks (user_id, current_streak, best_streak, last_active) VALUES (2, 12, 12, CURDATE());

-- ============================================================
-- SAMPLE QUERIES
-- ============================================================

-- Daily calorie summary:
-- SELECT SUM(calories_kcal) cal, SUM(protein_g) prot, SUM(carbohydrates_g) carbs, SUM(fat_g) fat
-- FROM meal_logs WHERE user_id=2 AND log_date=CURDATE();

-- Weekly workout summary:
-- SELECT log_date, SUM(duration_minutes) mins, SUM(calories_burned) burned
-- FROM workout_logs WHERE user_id=2 AND log_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
-- GROUP BY log_date ORDER BY log_date;

-- BMI = weight_kg / ((height_cm/100)^2)

-- Weight trend:
-- SELECT metric_date, weight_kg, bmi FROM health_metrics
-- WHERE user_id=2 ORDER BY metric_date DESC LIMIT 30;

-- Food search:
-- SELECT * FROM food_items WHERE name LIKE '%chicken%'
-- ORDER BY is_verified DESC, name ASC LIMIT 20;

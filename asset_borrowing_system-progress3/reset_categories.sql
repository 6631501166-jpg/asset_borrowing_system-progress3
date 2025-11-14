-- ==========================================
-- Reset Categories Table
-- Remove all existing rows and add 4 new categories
-- ==========================================

-- Step 1: Remove all existing category rows
DELETE FROM categories;

-- Step 2: Reset auto-increment counter to start from 1
ALTER TABLE categories AUTO_INCREMENT = 1;

-- Step 3: Insert 4 new categories
-- Category names match image filenames (without .png extension)
INSERT INTO categories (category_name, image_url, description) VALUES
('macbook', 'http://192.168.1.185:3000/images/assets/macbook.png', 'MacBook and laptop devices'),
('ipad', 'http://192.168.1.185:3000/images/assets/ipad.png', 'iPad and tablet devices'),
('playstation', 'http://192.168.1.185:3000/images/assets/playstation.png', 'PlayStation gaming consoles'),
('vr', 'http://192.168.1.185:3000/images/assets/vr.png', 'Virtual Reality headsets and equipment');

-- Step 4: Verify the new data
SELECT * FROM categories ORDER BY category_id;

-- Expected output:
-- +-------------+-------------+----------------------------------------------+------------------------------------------+
-- | category_id | category_name | image_url                                   | description                              |
-- +-------------+-------------+----------------------------------------------+------------------------------------------+
-- |           1 | macbook     | http://192.168.1.185:3000/images/assets/... | MacBook and laptop devices               |
-- |           2 | ipad        | http://192.168.1.185:3000/images/assets/... | iPad and tablet devices                  |
-- |           3 | playstation | http://192.168.1.185:3000/images/assets/... | PlayStation gaming consoles              |
-- |           4 | vr          | http://192.168.1.185:3000/images/assets/... | Virtual Reality headsets and equipment   |
-- +-------------+-------------+----------------------------------------------+------------------------------------------+

-- DONE! 
-- You now have 4 fresh categories: macbook, ipad, playstation, vr
-- Make sure to add the corresponding PNG files to: backend/public/images/assets/

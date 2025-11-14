-- Sample Assets for Testing
-- This script adds 3 assets for each category (Macbook, iPad, Playstation, VR Headset)

-- Clear existing assets (optional - uncomment if needed)
-- DELETE FROM asset WHERE category_id IN (1, 2, 3, 4);

-- Macbook Assets (category_id = 1)
INSERT INTO asset (asset_code, asset_name, category_id, status, created_at) VALUES
('MAC-001', 'MacBook Pro M1 13-inch', 1, 'available', NOW()),
('MAC-002', 'MacBook Pro M2 14-inch', 1, 'available', NOW()),
('MAC-003', 'MacBook Air M2', 1, 'available', NOW());

-- iPad Assets (category_id = 2)
INSERT INTO asset (asset_code, asset_name, category_id, status, created_at) VALUES
('IPAD-001', 'iPad Pro 12.9-inch', 2, 'available', NOW()),
('IPAD-002', 'iPad Air 5th Gen', 2, 'available', NOW()),
('IPAD-003', 'iPad Mini 6th Gen', 2, 'available', NOW());

-- Playstation Assets (category_id = 3)
INSERT INTO asset (asset_code, asset_name, category_id, status, created_at) VALUES
('PS-001', 'PlayStation 5 Digital', 3, 'available', NOW()),
('PS-002', 'PlayStation 5 Disc', 3, 'available', NOW()),
('PS-003', 'PlayStation 5 Slim', 3, 'available', NOW());

-- VR Headset Assets (category_id = 4)
INSERT INTO asset (asset_code, asset_name, category_id, status, created_at) VALUES
('VR-001', 'Meta Quest 3', 4, 'available', NOW()),
('VR-002', 'PlayStation VR2', 4, 'available', NOW()),
('VR-003', 'HTC Vive Pro 2', 4, 'available', NOW());

-- Verify the data
SELECT a.asset_id, a.asset_code, a.asset_name, c.name AS category_name, a.status
FROM asset a
JOIN category c ON a.category_id = c.category_id
ORDER BY c.name, a.asset_code;

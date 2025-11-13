CREATE TABLE nutrition (
    id TEXT PRIMARY KEY,            -- 서버 nutrition.id 그대로 저장
    product_id TEXT NOT NULL,
    
    per_serving_grams REAL,
    calories REAL,
    carbs_g REAL,
    sugar_g REAL,
    protein_g REAL,
    fat_g REAL,
    sat_fat_g REAL,
    trans_fat_g REAL,
    sodium_mg REAL,
    fiber_g REAL,
    cholesterol_mg REAL,
    vitamins TEXT,

    label_version INTEGER NOT NULL,

    updated_at TEXT NOT NULL,       -- 서버 updated_at (캐시 검증용)

    FOREIGN KEY(product_id) REFERENCES product(id) ON DELETE CASCADE,
    UNIQUE(product_id, label_version)
);

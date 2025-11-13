CREATE TABLE ingredient (
    id TEXT PRIMARY KEY,                -- 로컬 PK(UUID)
    server_id TEXT,                     -- 서버의 ingredient.id
    product_id TEXT NOT NULL,
    raw_ingredient TEXT NOT NULL,
    norm_text TEXT,
    allergen_tags TEXT,                 -- JSON 문자열
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    FOREIGN KEY(product_id) REFERENCES product(id) ON DELETE CASCADE
);

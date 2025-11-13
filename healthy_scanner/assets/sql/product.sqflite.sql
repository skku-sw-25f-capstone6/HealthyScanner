CREATE TABLE product (
    id TEXT PRIMARY KEY,                -- 로컬 UUID

    barcode TEXT UNIQUE,                -- 바코드 원문
    barcode_kind TEXT,                  -- 'EAN13' | 'UPC' | 'CODE128'
    brand TEXT,
    name TEXT,
    category TEXT,
    size_text TEXT,
    image_url TEXT,
    country TEXT,
    notes TEXT,
    score INTEGER,

    created_at TEXT NOT NULL,           -- ISO8601 문자열 (앱에서 넣음)
    updated_at TEXT NOT NULL,           -- 앱에서 직접 업데이트

    CHECK (
        barcode IS NULL OR
        (
            barcode GLOB '[0-9]*' AND 
            LENGTH(barcode) IN (8, 12, 13, 14)
        )
    )
);

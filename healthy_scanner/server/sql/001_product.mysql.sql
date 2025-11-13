CREATE TABLE product (
    id CHAR(36) PRIMARY KEY,        -- 제품 고유 UUID

    barcode VARCHAR(32) UNIQUE,     -- EAN/UPC/Code128
    barcode_kind VARCHAR(16),       -- 'EAN13'|'UPC'|'CODE128'
    brand VARCHAR(128),
    name VARCHAR(256),
    category VARCHAR(128),
    size_text VARCHAR(64),
    image_url TEXT,
    country VARCHAR(64),
    notes TEXT,
    score INTEGER,

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),

    CHECK (
        barcode IS NULL OR
        (barcode REGEXP '^[0-9]{8}$'
         OR barcode REGEXP '^[0-9]{12}$'
         OR barcode REGEXP '^[0-9]{13}$'
         OR barcode REGEXP '^[0-9]{14}$')
    )
);
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
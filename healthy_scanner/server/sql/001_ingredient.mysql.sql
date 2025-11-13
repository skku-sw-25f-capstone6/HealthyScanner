CREATE TABLE ingredient (
    id CHAR(36) PRIMARY KEY,                       -- 상품의 성분 설명에 대한 id (UUID)
    product_id CHAR(36) NOT NULL,

    raw_ingredient TEXT NOT NULL,                  -- 라벨 표기 원문, gpt가 이거 보고 진단 내림
    norm_text TEXT,                                -- 정규화를 하기 위한 문자열
    allergen_tags TEXT,                            -- JSON ["peanut","wheat"]
    order_index INTEGER NOT NULL DEFAULT 0,        -- 라벨마다의 순서가 있음

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                  ON UPDATE CURRENT_TIMESTAMP(6),

    FOREIGN KEY(product_id) REFERENCES product(id) ON DELETE CASCADE
);
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
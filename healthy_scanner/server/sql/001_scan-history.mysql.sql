CREATE TABLE scan_history (
    id CHAR(36) PRIMARY KEY,                  -- 스캔 기록 UUID
    user_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,

    scanned_at DATETIME(6) NOT NULL,          -- 스캔 시각

    decision ENUM('avoid','caution','ok'),    -- NULL 허용(아직 분석 전 등)

    summary VARCHAR(255),                     -- 예: "당류 25g/회 → 고당"
    ai_total_score TINYINT UNSIGNED,          -- 0~100 (0~33 나쁨, 34~66 보통, 67~100 좋음)

    conditions JSON,                          -- ["diabetes", ...]
    allergies  JSON,                          -- ["peanut", ...]
    habits     JSON,                          -- ["low_sugar", ...]

    ai_allergy_report   TEXT,                 -- 예: "땅콩 알레르기 주의"
    ai_condition_report TEXT,                 -- 예: "당뇨 환자 주의"
    ai_alter_report     TEXT,                 -- 예: "저당 제품 추천"
    ai_vegan_report     TEXT,                 -- 예: "비건 제품 아님"
    ai_total_report     TEXT,                 -- 예: "당류 25g/회로 당뇨 환자 주의"

    caution_factors JSON,                     -- 예: [{"key":"heart_disease","level":"red"}, ...]

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at DATETIME(6) NULL,              -- soft delete

    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;

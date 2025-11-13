CREATE TABLE scan_history (
    id TEXT PRIMARY KEY,                      -- 로컬 PK (UUID)
    server_id TEXT,                           -- 서버 scan_history.id

    user_id TEXT NOT NULL,
    product_id TEXT NOT NULL,

    scanned_at TEXT NOT NULL,                 -- ISO8601 문자열 (예: "2025-11-13T19:32:00Z")

    decision TEXT
        CHECK (decision IN ('avoid','caution','ok') OR decision IS NULL),

    summary TEXT,                             -- 예: "당류 25g/회 → 고당"
    ai_total_score INTEGER
        CHECK (ai_total_score IS NULL OR (ai_total_score >= 0 AND ai_total_score <= 100)),

    conditions TEXT,                          -- JSON 문자열 ["diabetes", ...]
    allergies  TEXT,                          -- JSON 문자열 ["peanut", ...]
    habits     TEXT,                          -- JSON 문자열 ["low_sugar", ...]

    ai_allergy_report   TEXT,
    ai_condition_report TEXT,
    ai_alter_report     TEXT,
    ai_vegan_report     TEXT,
    ai_total_report     TEXT,

    caution_factors TEXT,                     -- JSON 문자열 (서버의 JSON과 동일 구조)

    created_at TEXT NOT NULL,                 -- 로컬 생성 시각(ISO8601)
    updated_at TEXT NOT NULL,                 -- 마지막 수정 시각
    deleted_at TEXT,                          -- soft delete 플래그용 (NULL이면 정상 레코드)

    FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE,
    FOREIGN KEY(product_id) REFERENCES product(id) ON DELETE CASCADE
);

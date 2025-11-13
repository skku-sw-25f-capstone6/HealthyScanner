CREATE TABLE user (
    id TEXT PRIMARY KEY,                             -- UUID v4 권장
    name TEXT,
    habits     JSON,                                 -- JSON 문자열
    conditions JSON,                                 -- JSON 문자열 (원하면 json_valid 체크 추가 가능)
    allergies  JSON,                                 -- JSON 문자열
    -- scan_count INTEGER DEFAULT 0,                    -- 이건 나중에 너무 불편하다 싶으면 풀자
    
    -- 🔒 토큰 관리 추가 부분(로그인 관련)
    refresh_token_hash TEXT,                         -- refresh_token 해시 (원문 저장 금지)
	refresh_token_issued_at TEXT,                    -- 발급 시각
    refresh_token_expires_at TEXT,                   -- 만료 시각
    refresh_token_revoked_at TEXT,                   -- 로그아웃/폐기 시각
    
    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
    deleted_at DATETIME(6) NULL
);
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
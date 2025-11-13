CREATE TABLE user_daily_score (
  user_id         CHAR(36) NOT NULL COMMENT 'FK user(id)',         -- UUID
  local_date      DATE NOT NULL COMMENT '사용자 로컬 기준 날짜',    -- YYYY-MM-DD

  score           TINYINT UNSIGNED NOT NULL
                  CHECK (score BETWEEN 0 AND 100),

  -- 부가 지표
  num_scans       INT UNSIGNED NOT NULL DEFAULT 0,
  max_severity    ENUM('none','info','warning','danger') NULL,
  decision_counts JSON NULL,                                       -- {"ok":n,"caution":n,"avoid":n}

  -- 산식/버전/상태
  formula_version INT UNSIGNED NOT NULL DEFAULT 1,
  dirty           TINYINT(1) NOT NULL DEFAULT 0,                   -- 1이면 재계산 필요
  last_computed_at DATETIME(6) NULL,                               -- UTC

  -- 공통 메타
  created_at      DATETIME(6) NOT NULL
                  DEFAULT CURRENT_TIMESTAMP(6),
  updated_at      DATETIME(6) NOT NULL
                  DEFAULT CURRENT_TIMESTAMP(6)
                  ON UPDATE CURRENT_TIMESTAMP(6),
  deleted_at      DATETIME(6) NULL,                                -- soft delete (원하면 제거 가능)
  sync_state      TINYINT NOT NULL DEFAULT 1,                      -- 필요 없으면 서버에선 빼도 됨

  PRIMARY KEY (user_id, local_date),

  CONSTRAINT fk_user_daily_score_user
    FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
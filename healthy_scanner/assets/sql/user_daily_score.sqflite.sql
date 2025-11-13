CREATE TABLE user_daily_score (
  user_id          TEXT NOT NULL,                     -- FK user(id)
  local_date       TEXT NOT NULL,                     -- 'YYYY-MM-DD'
  score            INTEGER NOT NULL CHECK (score BETWEEN 0 AND 100),

  num_scans        INTEGER NOT NULL DEFAULT 0,
  max_severity     TEXT CHECK (max_severity IN ('none','info','warning','danger') OR max_severity IS NULL),
  decision_counts  TEXT,                              -- JSON {"ok":n, ...}

  formula_version  INTEGER NOT NULL DEFAULT 1,
  dirty            INTEGER NOT NULL DEFAULT 0,
  last_computed_at TEXT,                              -- ISO8601 UTC

  created_at       TEXT NOT NULL,
  updated_at       TEXT NOT NULL,
  deleted_at       TEXT,
  sync_state       INTEGER NOT NULL DEFAULT 1,

  PRIMARY KEY (user_id, local_date),
  FOREIGN KEY(user_id) REFERENCES user(id) ON DELETE CASCADE
);

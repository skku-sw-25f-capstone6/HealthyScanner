CREATE TABLE user (
    id TEXT PRIMARY KEY,                               -- 로컬 UUID
    server_id TEXT UNIQUE,                             -- 서버 user.id 매핑

    name TEXT,

    habits     TEXT,                                   -- JSON 문자열
    conditions TEXT,                                   -- JSON 문자열
    allergies  TEXT,                                   -- JSON 문자열

    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ','now')),
    deleted_at TEXT,

    sync_state INTEGER NOT NULL DEFAULT 1              -- 0=sync,1=local_only,2=pending,3=needs_merge
);

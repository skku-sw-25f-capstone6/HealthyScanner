CREATE TABLE nutrition (
    id CHAR(36) PRIMARY KEY,                  -- 서버가 관리하는 nutrition UUID
    product_id CHAR(36) NOT NULL,             -- product.id(FK)

    per_serving_grams DOUBLE CHECK (per_serving_grams IS NULL OR per_serving_grams > 0),
    calories        DOUBLE CHECK (calories      IS NULL OR calories      >= 0),
    carbs_g         DOUBLE CHECK (carbs_g       IS NULL OR carbs_g       >= 0),
    sugar_g         DOUBLE CHECK (sugar_g       IS NULL OR sugar_g       >= 0),
    protein_g       DOUBLE CHECK (protein_g     IS NULL OR protein_g     >= 0),
    fat_g           DOUBLE CHECK (fat_g         IS NULL OR fat_g         >= 0),
    sat_fat_g       DOUBLE CHECK (sat_fat_g     IS NULL OR sat_fat_g     >= 0),
    trans_fat_g     DOUBLE CHECK (trans_fat_g   IS NULL OR trans_fat_g   >= 0),
    sodium_mg       DOUBLE CHECK (sodium_mg     IS NULL OR sodium_mg     >= 0),
    cholesterol_mg  DOUBLE CHECK (cholesterol_mg IS NULL OR cholesterol_mg >= 0),

    label_version INT NOT NULL DEFAULT 1,     -- 같은 product의 라벨 버전 관리

    created_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    updated_at DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6)
                                  ON UPDATE CURRENT_TIMESTAMP(6),

    CONSTRAINT fk_nutrition_product
        FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,

    CONSTRAINT uq_nutrition_product_label
        UNIQUE (product_id, label_version)
);
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_unicode_ci;
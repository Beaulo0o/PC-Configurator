CREATE TABLE users (
  id BIGSERIAL PRIMARY KEY,
  login VARCHAR(80) NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role VARCHAR(20) NOT NULL CHECK (role IN ('user','admin')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE categories (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  code VARCHAR(40) NOT NULL UNIQUE
);
CREATE TABLE manufacturers (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(160) NOT NULL UNIQUE
);
CREATE TABLE components (
  id BIGSERIAL PRIMARY KEY,
  category_id BIGINT NOT NULL REFERENCES categories(id),
  manufacturer_id BIGINT NOT NULL REFERENCES manufacturers(id),
  name VARCHAR(200) NOT NULL,
  base_price NUMERIC(12,2) NOT NULL CHECK (base_price >= 0),
  characteristics JSONB NOT NULL DEFAULT '{}'::jsonb,
  power_watts NUMERIC(8,2) CHECK (power_watts IS NULL OR power_watts >= 0),
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE (manufacturer_id, name)
);
CREATE TABLE price_sources (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(160) NOT NULL UNIQUE,
  address TEXT,
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE component_prices (
  id BIGSERIAL PRIMARY KEY,
  component_id BIGINT NOT NULL REFERENCES components(id),
  source_id BIGINT NOT NULL REFERENCES price_sources(id),
  product_name VARCHAR(250) NOT NULL,
  price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
  product_url TEXT,
  availability VARCHAR(80),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (component_id, source_id)
);
CREATE TABLE builds (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  name VARCHAR(160) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE build_components (
  build_id BIGINT NOT NULL REFERENCES builds(id) ON DELETE CASCADE,
  component_id BIGINT NOT NULL REFERENCES components(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  PRIMARY KEY (build_id, component_id)
);
CREATE TABLE build_validations (
  id BIGSERIAL PRIMARY KEY,
  build_id BIGINT NOT NULL REFERENCES builds(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL CHECK (status IN ('compatible','incomplete','incompatible')),
  checked_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE validation_messages (
  id BIGSERIAL PRIMARY KEY,
  validation_id BIGINT NOT NULL REFERENCES build_validations(id) ON DELETE CASCADE,
  severity VARCHAR(20) NOT NULL CHECK (severity IN ('warning','error')),
  code VARCHAR(60) NOT NULL,
  message TEXT NOT NULL
);
CREATE INDEX idx_components_active ON components (category_id, is_active);
CREATE INDEX idx_components_characteristics ON components USING GIN (characteristics);
CREATE INDEX idx_component_prices_component ON component_prices (component_id);
CREATE INDEX idx_builds_user ON builds (user_id);

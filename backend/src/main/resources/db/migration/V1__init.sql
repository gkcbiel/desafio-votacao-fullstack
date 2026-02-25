CREATE TABLE IF NOT EXISTS pauta (
  id          BIGSERIAL PRIMARY KEY,
  titulo      VARCHAR(120) NOT NULL,
  descricao   TEXT,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS sessao_votacao (
  id               BIGSERIAL PRIMARY KEY,
  pauta_id         BIGINT      NOT NULL REFERENCES pauta(id) ON DELETE CASCADE,
  opened_at        TIMESTAMPTZ NOT NULL,
  closes_at        TIMESTAMPTZ NOT NULL,
  duration_seconds INT         NOT NULL CHECK (duration_seconds > 0),
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_sessao_votacao_pauta
  ON sessao_votacao(pauta_id);

CREATE INDEX IF NOT EXISTS idx_sessao_votacao_pauta
  ON sessao_votacao(pauta_id);

CREATE TABLE IF NOT EXISTS voto (
  id         BIGSERIAL PRIMARY KEY,
  pauta_id   BIGINT      NOT NULL REFERENCES pauta(id) ON DELETE CASCADE,
  cpf        VARCHAR(11) NOT NULL,
  escolha    VARCHAR(3)  NOT NULL CHECK (escolha IN ('SIM','NAO')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT uq_voto_pauta_cpf UNIQUE (pauta_id, cpf)
);

CREATE INDEX IF NOT EXISTS idx_voto_pauta
  ON voto(pauta_id);

CREATE INDEX IF NOT EXISTS idx_voto_pauta_escolha
  ON voto(pauta_id, escolha);

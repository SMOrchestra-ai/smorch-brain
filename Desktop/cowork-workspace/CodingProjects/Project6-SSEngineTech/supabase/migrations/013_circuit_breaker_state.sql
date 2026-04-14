-- Migration 013: Circuit Breaker State Table
-- Tracks health/failure state of external API integrations for observability dashboard.

CREATE TABLE IF NOT EXISTS public.circuit_breaker_state (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  api_name text NOT NULL UNIQUE,
  state text NOT NULL DEFAULT 'closed' CHECK (state IN ('closed', 'open', 'half_open')),
  failure_count integer NOT NULL DEFAULT 0,
  last_failure_at timestamptz,
  last_success_at timestamptz,
  cooldown_until timestamptz,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE public.circuit_breaker_state ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Authenticated users can view circuit breaker state"
  ON public.circuit_breaker_state FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Service role can manage circuit breaker state"
  ON public.circuit_breaker_state FOR ALL
  TO service_role
  USING (true);

-- Auto-update updated_at on row change
CREATE OR REPLACE FUNCTION public.set_circuit_breaker_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER circuit_breaker_updated_at
  BEFORE UPDATE ON public.circuit_breaker_state
  FOR EACH ROW
  EXECUTE FUNCTION public.set_circuit_breaker_updated_at();

-- Seed 7 monitored API integrations
INSERT INTO public.circuit_breaker_state (api_name, state, failure_count) VALUES
  ('clay', 'closed', 0),
  ('instantly', 'closed', 0),
  ('heyreach', 'closed', 0),
  ('ghl', 'closed', 0),
  ('claude', 'closed', 0),
  ('gemini', 'closed', 0),
  ('apify', 'closed', 0)
ON CONFLICT (api_name) DO NOTHING;

-- ============================================================
-- DOWN MIGRATION (rollback):
-- DROP TRIGGER IF EXISTS circuit_breaker_updated_at ON public.circuit_breaker_state;
-- DROP FUNCTION IF EXISTS public.set_circuit_breaker_updated_at();
-- DROP TABLE IF EXISTS public.circuit_breaker_state;
-- ============================================================

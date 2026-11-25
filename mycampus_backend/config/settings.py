"""Environment-driven application settings.

Values come from environment variables or an optional ``.env`` file next to
the backend package. Defaults are development-only; copy ``.env.example`` and
change ``SECRET_KEY`` before any non-local deployment.
"""

from __future__ import annotations

from pathlib import Path

from pydantic_settings import BaseSettings, SettingsConfigDict

ENV_FILE = Path(__file__).resolve().parent.parent / ".env"


class Settings(BaseSettings):
    app_host: str = "0.0.0.0"
    app_port: int = 8001
    app_env: str = "development"
    api_prefix: str = "/api/v1"

    # SQLite is the only supported server-side database.
    database_url: str = "sqlite:///./mycampus.db"

    secret_key: str = "change-this-to-a-long-random-secret"
    access_token_ttl_minutes: int = 1440

    cors_origins: str = "*"
    sql_echo: bool = False

    model_config = SettingsConfigDict(
        env_file=str(ENV_FILE),
        env_file_encoding="utf-8",
        case_sensitive=False,
        extra="ignore",
    )

    @property
    def is_sqlite(self) -> bool:
        return self.database_url.startswith("sqlite")

    @property
    def allowed_origins(self) -> list[str]:
        return [origin.strip() for origin in self.cors_origins.split(",") if origin.strip()]


settings = Settings()

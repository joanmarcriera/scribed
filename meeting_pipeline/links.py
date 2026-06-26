"""Outbound links shown in the app, kept in one place.

The donate link is a Lemon Squeezy "Pay What You Want" checkout. Lemon Squeezy's
API is read-only for products/variants, so the product is created once in the LS
dashboard (store: marcriera) and its public "Buy now" URL is pasted below.

Until ``DONATE_URL`` is set, every Support affordance (menu item, settings link,
README badge) is hidden — the app never shows a dead link.
"""

from __future__ import annotations

# Lemon Squeezy "Pay What You Want" checkout for the Seshat donations product
# (marcriera store). Verified live (HTTP 200).
DONATE_URL: str = "https://marcriera.lemonsqueezy.com/checkout/buy/e71c4ce2-f423-4bb6-9883-268e2324035d"

PROJECT_URL: str = "https://github.com/Joanmarcriera/seshat"


def donate_url() -> str:
    """Return the configured donate URL (stripped), or "" if none is set."""
    return DONATE_URL.strip()

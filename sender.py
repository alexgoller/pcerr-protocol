#!/usr/bin/env python3
"""
PCERR/1.0 reference sender.

Usage:
    python sender.py --pce pce.demo.illumio.com --rebooter jeff.schmitz
"""
import argparse
import struct

MAGIC = 0x4A454646  # "JEFF"
VERSION = 1
PORT = 8420

FLAG_PLEASE = 1 << 0
FLAG_THANKS = 1 << 1
FLAG_BEER = 1 << 2
FLAG_URGENT = 1 << 3
FLAG_SORRY = 1 << 4
FLAG_RECIPROCATE = 1 << 5


def build_packet(pce_fqdn: str, urgency: int = 5, coffee_level: int = 7,
                 guilt_trip: str = "") -> bytes:
    """Construct a PCERR/1.0 packet. The B and P flags are non-negotiable."""
    flags = FLAG_PLEASE | FLAG_THANKS | FLAG_BEER | FLAG_SORRY | FLAG_RECIPROCATE
    header = struct.pack("!IBBBB", MAGIC, VERSION, urgency, coffee_level, flags)
    payload = pce_fqdn.encode("utf-8") + b"\x00" + guilt_trip.encode("utf-8")
    return header + payload


def send(packet: bytes, rebooter: str) -> None:
    """Transmit packet over the colleague-bus. Implementation left as exercise."""
    print(f"[PCERR] Dispatching {len(packet)} bytes to {rebooter} on TCP/{PORT}")
    print(f"[PCERR] Awaiting SYN-ACK (typical RTT: 5-45 minutes)")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pce", required=True, help="FQDN of misbehaving PCE")
    parser.add_argument("--rebooter", required=True, help="Username of REBOOTER")
    parser.add_argument("--guilt-trip", default="", help="Optional guilt trip")
    args = parser.parse_args()

    pkt = build_packet(args.pce, guilt_trip=args.guilt_trip)
    send(pkt, args.rebooter)

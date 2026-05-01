# PCERR — PCE Reboot Request Protocol

> RFC 8420.69 — A stateful, colleague-oriented signaling mechanism for politely nudging a fellow engineer to power-cycle a Policy Compute Engine on one's behalf.

[![Status](https://img.shields.io/badge/status-experimental-orange)](#)
[![Layer](https://img.shields.io/badge/OSI%20Layer-8%20(Politeness)-blue)](#)
[![Coffee Required](https://img.shields.io/badge/coffee-required-brown)](#)

## Abstract

This document specifies the **PCE Reboot Request (PCERR)** protocol. PCERR operates at OSI Layer 8 (Politeness) and assumes the receiving colleague is awake, caffeinated, and not currently in a customer call.

## 1. Terminology

- **REQUESTER** — The party whose PCE is misbehaving.
- **REBOOTER** — The colleague kindly asked to perform the reboot.
- **PCE** — Policy Compute Engine. The thing that needs a kick.
- **MUST**, **SHOULD**, **PLEASE** — As defined in RFC 2119, plus one extra word for manners.

## 2. Packet Format

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  MAGIC: 0x4A454646 ("JEFF")                                   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| VER=1 | URGENCY |  COFFEE_LEVEL  |       FLAGS               |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  PCE_FQDN (variable, null-terminated)                         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  GUILT_TRIP (UTF-8, optional)                                 |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

## 3. Flag Bits

| Bit | Name | Meaning |
|-----|------|---------|
| 0 | `P` | Please |
| 1 | `T` | Thanks in advance |
| 2 | `B` | Beer offered as compensation |
| 3 | `U` | Urgent (customer is watching) |
| 4 | `S` | Sorry to bother you |
| 5 | `R` | Will return the favor |
| 6-7 | Reserved | MUST be set to `🙏` |

## 4. Three-Way Handshake

```
REQUESTER                          REBOOTER
    |                                  |
    | -------- SYN (PCERR) ----------> |   "Hey, my PCE is being weird"
    |                                  |
    | <----- SYN-ACK (rebooting) ----- |   "On it, gimme a sec"
    |                                  |
    | -------- ACK (beer owed) ------> |   "Legend, I owe you one"
    |                                  |
```

## 5. Error Codes

| Code | Meaning |
|------|---------|
| `200 OK` | PCE rebooted, you owe REBOOTER a beer |
| `418 I'm a Teapot` | REBOOTER is in a meeting |
| `420 Enhance Your Calm` | REBOOTER says "have you tried turning it off and on again?" |
| `451 Unavailable For Legal Reasons` | REBOOTER is on PTO |
| `503 Service Unavailable` | REBOOTER's coffee level is critical |

## 6. Security Considerations

The `B` (beer) flag MUST be honored. Failure to deliver compensation results in protocol degradation and increased latency on future PCERR requests. Implementations SHOULD cache outstanding beer debt in non-volatile storage (i.e., a sticky note on the laptop).

## 7. IANA Considerations

The well-known port for PCERR is **TCP/8420**. The MAGIC value `0x4A454646` ("JEFF") is reserved and MUST NOT be used by other protocols without prior consultation with the named REBOOTER.

## 8. Reference Implementation

See [`examples/`](./examples/) for a sample PCERR/1.0 transmission and a Python sender stub.

## 9. Contributors

- **alexgoller** — Editor, REQUESTER reference implementation
- **jdschmitz** — REBOOTER reference implementation, beer recipient

## 10. License

MIT. See [LICENSE](./LICENSE).

---

*This document is a joke. Mostly.*

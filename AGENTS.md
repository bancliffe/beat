# AGENTS.md — AI agent instructions for this Pico-8 project

Purpose
- Short guidance to help AI coding agents be productive working on this repo (a Pico-8 cartridge).

What this project is
- Single Pico-8 cartridge: `beat.p8` (retro rhythm/beat prototype).

Quick start (what agents need to know)
- Primary source: [beat.p8](beat.p8)
- Edit in the Pico-8 editor and run there for live preview. If using CLI automation, reference the official Pico-8 manual for exact CLI flags.

Conventions & constraints
- Target runtime: Pico-8 fantasy console. Common constraints agents should assume: 128×128 screen, 16-color palette, 8×8 sprite cells, and the cartridge format (`.p8`). For authoritative limits and export details, link to the Pico-8 manual rather than duplicating it.
- Keep changes minimal and focused: prefer small, testable edits to `beat.p8` rather than large refactors.
- Assets (sprites, map, music/sfx) live inside the cartridge; avoid creating large external binaries unless requested.

Agent behavior guidelines
- Ask before making breaking changes that would alter the cartridge format or delete art/audio.
- When proposing new features, provide a concise design note and a short play-test checklist (controls + expected behavior).
- If generating code for Pico-8, follow its Lua-style syntax and keep functions short. Provide a short usage example and how to test it in the editor.

Links
- Pico-8 manual: https://www.lexaloffle.com/pico-8.php

If you want, I can also add small helper prompts (skills) for: sprite/map editing, music/sfx stubs, or a cartridge scaffolding template. Tell me which one to create next.

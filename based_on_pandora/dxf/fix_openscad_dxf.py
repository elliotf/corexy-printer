#!/usr/bin/env python3
"""Convert OpenSCAD-exported DXF files into valid AutoCAD R12 (AC1009) DXF files
with millimeter units ($INSUNITS=4, $MEASUREMENT=1) for services like SendCutSend.

Fixes OpenSCAD DXF issues:
1. Changes $ACADVER from AC1006 to AC1009 (R12).
2. Fixes $LINMIN/$LINMAX header typos to $LIMMIN/$LIMMAX and ensures 3D $EXTMIN/$EXTMAX.
3. Adds $INSUNITS = 4 (Millimeters) and $MEASUREMENT = 1 (Metric) to HEADER.
4. Converts R14+ LWPOLYLINE entities (with 100 AcDb* subclass markers) into
   standard R12 POLYLINE + VERTEX + SEQEND entities (supports multiple polylines/holes).
"""

import argparse
from pathlib import Path
import sys


def parse_pairs(lines: list[str]) -> list[tuple[int, str]]:
    """Parse raw DXF lines into (group_code, value) pairs."""
    pairs: list[tuple[int, str]] = []
    for i in range(0, len(lines) - 1, 2):
        code_str = lines[i].strip()
        val_str = lines[i + 1].strip()
        if not code_str and not val_str:
            continue
        pairs.append((int(code_str), val_str))
    return pairs


def format_pair(code: int, value: str) -> list[str]:
    """Format a (group_code, value) pair in standard DXF spacing."""
    return [f"{code:3d}", value]


def convert_header(header_pairs: list[tuple[int, str]]) -> list[tuple[int, str]]:
    """Fix OpenSCAD HEADER variables and inject millimeter unit settings."""
    out: list[tuple[int, str]] = []
    has_insunits = False
    has_measurement = False

    i = 0
    n = len(header_pairs)
    while i < n:
        code, val = header_pairs[i]
        if code == 9:
            var_name = val
            # Collect all pairs belonging to this header variable
            var_pairs: list[tuple[int, str]] = []
            i += 1
            while i < n and header_pairs[i][0] != 9:
                var_pairs.append(header_pairs[i])
                i += 1

            if var_name == "$ACADVER":
                out.append((9, "$ACADVER"))
                out.append((1, "AC1009"))
            elif var_name in ("$LINMIN", "$LIMMIN"):
                out.append((9, "$LIMMIN"))
                out.extend(var_pairs)
            elif var_name in ("$LINMAX", "$LIMMAX"):
                out.append((9, "$LIMMAX"))
                out.extend(var_pairs)
            elif var_name in ("$EXTMIN", "$EXTMAX"):
                out.append((9, var_name))
                out.extend(var_pairs)
                if not any(c == 30 for c, _ in var_pairs):
                    out.append((30, "0.0"))
            elif var_name == "$INSUNITS":
                has_insunits = True
                out.append((9, "$INSUNITS"))
                out.append((70, "4"))
            elif var_name == "$MEASUREMENT":
                has_measurement = True
                out.append((9, "$MEASUREMENT"))
                out.append((70, "1"))
            else:
                out.append((9, var_name))
                out.extend(var_pairs)
        else:
            out.append((code, val))
            i += 1

    if not has_insunits:
        out.extend([(9, "$INSUNITS"), (70, "4")])
    if not has_measurement:
        out.extend([(9, "$MEASUREMENT"), (70, "1")])

    return out


def convert_lwpolyline(entity_pairs: list[tuple[int, str]]) -> list[tuple[int, str]]:
    """Convert a single LWPOLYLINE entity's pairs into R12 POLYLINE + VERTEX + SEQEND."""
    layer = "0"
    flags = "1"
    vertices: list[tuple[str, str]] = []
    cur_x: str | None = None

    for code, val in entity_pairs:
        if code == 8:
            layer = val
        elif code == 70:
            flags = val
        elif code == 10:
            cur_x = val
        elif code == 20 and cur_x is not None:
            vertices.append((cur_x, val))
            cur_x = None

    out: list[tuple[int, str]] = [
        (0, "POLYLINE"),
        (8, layer),
        (66, "1"),
        (10, "0.0"),
        (20, "0.0"),
        (30, "0.0"),
        (70, flags),
    ]
    for x, y in vertices:
        out.extend([
            (0, "VERTEX"),
            (8, layer),
            (10, x),
            (20, y),
            (30, "0.0"),
        ])
    out.extend([
        (0, "SEQEND"),
        (8, layer),
    ])
    return out


def convert_entities(entities_pairs: list[tuple[int, str]]) -> list[tuple[int, str]]:
    """Convert all LWPOLYLINE entities in ENTITIES section to R12 POLYLINE."""
    out: list[tuple[int, str]] = []
    i = 0
    n = len(entities_pairs)

    while i < n:
        code, val = entities_pairs[i]
        if code == 0 and val == "LWPOLYLINE":
            i += 1
            ent_pairs: list[tuple[int, str]] = []
            while i < n and entities_pairs[i][0] != 0:
                ent_pairs.append(entities_pairs[i])
                i += 1
            out.extend(convert_lwpolyline(ent_pairs))
        else:
            # Strip any stray R14+ subclass markers (group code 100) if present
            if code != 100:
                out.append((code, val))
            i += 1

    return out


def convert_dxf_text(text: str) -> str:
    """Convert full OpenSCAD DXF text to R12 millimeter DXF text."""
    lines = text.splitlines()
    pairs = parse_pairs(lines)

    out_pairs: list[tuple[int, str]] = []
    i = 0
    n = len(pairs)

    while i < n:
        code, val = pairs[i]
        if code == 999:
            out_pairs.append((999, "DXF from OpenSCAD (R12 AC1009, mm)"))
            i += 1
        elif code == 0 and val == "SECTION":
            out_pairs.append((0, "SECTION"))
            i += 1
            if i < n and pairs[i][0] == 2:
                sec_name = pairs[i][1]
                out_pairs.append((2, sec_name))
                i += 1

                sec_pairs: list[tuple[int, str]] = []
                while i < n and not (pairs[i][0] == 0 and pairs[i][1] == "ENDSEC"):
                    sec_pairs.append(pairs[i])
                    i += 1

                if sec_name == "HEADER":
                    out_pairs.extend(convert_header(sec_pairs))
                elif sec_name == "ENTITIES":
                    out_pairs.extend(convert_entities(sec_pairs))
                else:
                    out_pairs.extend(sec_pairs)

                if i < n and pairs[i] == (0, "ENDSEC"):
                    out_pairs.append((0, "ENDSEC"))
                    i += 1
        else:
            out_pairs.append((code, val))
            i += 1

    out_lines: list[str] = []
    for c, v in out_pairs:
        out_lines.extend(format_pair(c, v))
    return "\n".join(out_lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Convert OpenSCAD DXF files to R12 (AC1009) DXF with mm units."
    )
    parser.add_argument(
        "files",
        nargs="+",
        type=Path,
        help="One or more DXF files to convert (modified in-place unless -o is used).",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="Output file path (only valid when converting a single input file).",
    )
    args = parser.parse_args()

    if args.output and len(args.files) > 1:
        parser.error("-o / --output can only be used with a single input file.")

    for src in args.files:
        if not src.is_file():
            print(f"Error: {src} does not exist.", file=sys.stderr)
            return 1
        converted = convert_dxf_text(src.read_text(encoding="utf-8"))
        dst = args.output if args.output else src
        dst.write_text(converted, encoding="utf-8")
        print(f"Converted {src} -> {dst} (R12 AC1009, mm)")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

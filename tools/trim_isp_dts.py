#!/usr/bin/env python3
"""Rebuild a Huawei isp_dts.img keeping only the entries of one platform."""
import hashlib
import os
import struct
import sys

if len(sys.argv) < 3:
    sys.exit(f"usage: {sys.argv[0]} <src> <dst> [platform]")

SRC = sys.argv[1]
DST = sys.argv[2]
PLATFORM = sys.argv[3] if len(sys.argv) > 3 else 'BOND'

d = open(SRC, 'rb').read()
magic, seg_size = struct.unpack_from('<4sI', d, 0)
count, hdr_size = struct.unpack_from('<HH', d, 8)
if magic != b'\xca\xca\xca\xca':
    sys.exit(f"{SRC}: unexpected magic {magic.hex()}")
print(f"src: seg_size={seg_size} count={count} hdr_size={hdr_size} size={len(d)}")

entries = []
for i in range(count):
    name_off, plat_off, data_off, ssize = struct.unpack_from('<IIII', d, 12 + i * 16)
    name = d[name_off:d.index(b'\0', name_off)].decode()
    plat = d[plat_off:d.index(b'\0', plat_off)].decode()
    entries.append(dict(idx=i, name=name, plat=plat, data_off=data_off, size=ssize))

# Sort by name so that the output is independent of the entry order of the
# source image: the zip based and the device dump based isp_dts.img list the
# same segments in different orders, which otherwise makes every extraction
# produce a spurious diff.
sel = sorted((e for e in entries if e['plat'] == PLATFORM),
             key=lambda e: e['name'])
if not sel:
    sys.exit(f"{SRC}: no entries for platform {PLATFORM}")
print(f"selected {len(sel)} entries for {PLATFORM}:")
for e in sel:
    print(f"  [{e['idx']:3d}] {e['name']:<28} off={e['data_off']} size={e['size']}")

n = len(sel)
dir_end = 12 + n * 16
name_blob = b''
positions = []
pos = dir_end
for e in sel:
    no = pos
    name_blob += e['name'].encode() + b'\0'
    pos += len(e['name']) + 1
    po = pos
    name_blob += e['plat'].encode() + b'\0'
    pos += len(e['plat']) + 1
    positions.append((no, po))

new_hdr_size = dir_end + len(name_blob)

dir_bytes = b''
data_cursor = new_hdr_size
for i, e in enumerate(sel):
    no, po = positions[i]
    dir_bytes += struct.pack('<IIII', no, po, data_cursor, e['size'])
    data_cursor += e['size']

head = (b'\xca\xca\xca\xca' + struct.pack('<I', seg_size) +
        struct.pack('<HH', n, new_hdr_size) + dir_bytes + name_blob)
assert len(head) == new_hdr_size, (len(head), new_hdr_size)

os.makedirs(os.path.dirname(os.path.abspath(DST)), exist_ok=True)
with open(DST, 'wb') as f:
    f.write(head)
    for e in sel:
        f.write(d[e['data_off']:e['data_off'] + e['size']])

expect = new_hdr_size + n * seg_size
actual = os.path.getsize(DST)
if actual != expect:
    sys.exit(f"{DST}: size {actual} != expected {expect}")

out = open(DST, 'rb').read()
bad = 0
for i, e in enumerate(sel):
    a = hashlib.md5(d[e['data_off']:e['data_off'] + e['size']]).hexdigest()
    b = hashlib.md5(out[new_hdr_size + i * e['size']:new_hdr_size + (i + 1) * e['size']]).hexdigest()
    if a != b:
        print(f"  seg[{i}] {e['name']}: MISMATCH")
        bad += 1

print(f"wrote {DST} size={actual} header={new_hdr_size} md5={hashlib.md5(out).hexdigest()}")
sys.exit(1 if bad else 0)

import { ec } from 'elliptic';
import CryptoJS from 'crypto-js';
import SHA256 from 'crypto-js/sha256';

const EC = new ec('secp256k1');

// derived key is different every time, IV is not needed
const SIG_PART_SZ = 32;

function wa2buff(_wa) {
  return Buffer.from(_wa.toString(), 'hex');
}

const service = {
  asPayload(_secret) {
    return `${_secret.publicKey}:${_secret.message || ''}`
  },
  recoverPublicKey(_secret) {
    if(!_secret.signature) return null;

    const payloadHash = SHA256(SHA256(service.asPayload(_secret)));
    const binSig = Buffer.from(_secret.signature, 'base64');

    let version = binSig.readInt8(0) // first byte
    if(version < 27 || version > 34) throw 'invalid signature';

    const compressed = version >= 31;
    if (compressed) version -= 4

    const pubKey = EC.recoverPubKey(wa2buff(payloadHash), {
      r: binSig.slice(1, SIG_PART_SZ + 1),
      s: binSig.slice(SIG_PART_SZ + 1, 2 * SIG_PART_SZ + 1)
    }, version - 27);

    if(!compressed) {
      return `04${pubKey.getX().toString(16)}${pubKey.getX().toString(16)}`
    } else if(pubKey.getY().isEven()) {
      return `02${pubKey.getX().toString(16)}`
    } else {
      return `03${pubKey.getX().toString(16)}`
    }
  },
};

export default service;

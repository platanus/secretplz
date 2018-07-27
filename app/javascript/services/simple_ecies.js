import { ec } from 'elliptic';
import CryptoJS from 'crypto-js';
import AES from 'crypto-js/aes';

const EC = new ec('secp256k1');

// derived key is different every time, IV is not needed
const COMPRESSED_KEY_SZ = 33;
const IV = CryptoJS.enc.Hex.parse('00000000000000000000000000000000');

function buffer2wa(_buffer) {
  return CryptoJS.enc.Hex.parse(_buffer.toString('hex'));
}

function bn2wa(_bn) {
  return CryptoJS.enc.Hex.parse(_bn.toString(16));
}

export default {
  encrypt(_publicKey, _message) {
    const publicKey = EC.keyFromPublic(Buffer.from(_publicKey, 'hex'));
    const ephemKey = EC.genKeyPair();

    const encryptionKeyWA = bn2wa(ephemKey.derive(publicKey.pub));
    const ciphertext = AES.encrypt(_message, encryptionKeyWA, { iv: IV });

    return ephemKey.getPublic(true, 'hex') + ciphertext.ciphertext.toString(CryptoJS.enc.Hex);
  },

  decrypt(_privateKey, _encryptedMessage) {
    const encryptedMessage = Buffer.from(_encryptedMessage, 'hex')
    const privateKey = EC.keyFromPrivate(Buffer.from(_privateKey, 'hex'));
    const ephemKey = EC.keyFromPublic(encryptedMessage.slice(0, COMPRESSED_KEY_SZ));

    const encryptionKeyWA = bn2wa(privateKey.derive(ephemKey.pub));
    const encryptedMessageWA = buffer2wa(encryptedMessage.slice(COMPRESSED_KEY_SZ));
    const ciphertext = AES.decrypt({ ciphertext: encryptedMessageWA }, encryptionKeyWA, { iv: IV });

    return ciphertext.toString(CryptoJS.enc.Utf8);
  },
};

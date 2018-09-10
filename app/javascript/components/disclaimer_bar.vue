<template>
  <div class="disclaimer-bar" v-if="secret">
    <div v-if="secret.signature">
      This message was signed using bitcoin message signing. The signed payload is: <span class="disclaimer-bar__data">{{ signedPayload }}</span>.
    </div>
    <div v-if="secret.signature">
      The following base64 encoded signature was provided: <span class="disclaimer-bar__data">{{ secret.signature }}</span>.
    </div>
    <div>
      Provided secret will be encoded using the following public key: <span class="disclaimer-bar__data">{{ `0x${secret.publicKey}` }}</span>.
    </div>
  </div>
</template>

<script>
import signature from '../services/signature_service';

export default {
  data: () => ({
    idKey: null,
  }),
  props: ['secret'],
  computed: {
    signedPayload() {
      return signature.asPayload(this.secret);
    },
  },
};
</script>
<style lang="scss">
.disclaimer-bar {
  position: relative;
  background: #c1b280;
  color: rgba(0, 0, 0, 0.60);
  font-size: 10px;
  padding: 10px;

  overflow: hidden;
  word-break: break-all;

  &__data {
    font-weight: bold;
  }
}
</style>

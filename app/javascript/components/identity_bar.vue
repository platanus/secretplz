<template>
  <div class="identity-bar">
    <div v-if="idKey">
      <img class="identity-bar__avatar" :src="avatarUrl"/>

      <div class="identity-bar__name">
        <div class="identity-bar__alias">
          {{ aliasKey }}
        </div>

        <div class="identity-bar__key">
          {{ splitKey }}
        </div>
      </div>
    </div>
    <div v-else class="identity-bar__anonymous">
      ANONYMOUS
    </div>
  </div>
</template>

<script>
import signature from '../services/signature_service';
import bs58 from 'bs58';

export default {
  data: () => ({
    idKey: null,
  }),
  props: ['secret'],
  computed: {
    avatarUrl() {
      return `https://robohash.org/${this.idKey}`;
    },
    aliasKey() {
      const b58id = bs58.encode(Buffer.from(this.idKey, 'hex')).toUpperCase().substr(0, 8);
      return `X-${b58id}`;
    },
    splitKey() {
      return `0x${this.idKey.substr(0, 32)}\n${this.idKey.substr(32, 66)}`
    }
  },
  watch: {
    secret: {
      immediate: true,
      handler(_secret) {
        if (_secret) {
          this.idKey = signature.recoverPublicKey(_secret);
        } else {
          this.idKey = null;
        }
      },
    },
  },
};
</script>
<style lang="scss">
.identity-bar {
  position: relative;
  overflow: hidden;
  background: #186573;

  &__avatar {
    transform: scaleX(-1);
    position: absolute;
    bottom: 0;
    left: 0;
    height: 100px;
  }

  &__name {
    padding: 5px;
    margin-left: 90px;
  }

  &__alias {
    font-size: 30px;
    color: rgba(255, 255, 255, 0.75);
  }

  &__key {
    font-family: monospace;
    font-size: 14px;
    color: rgba(255, 255, 255, 0.5);
  }

  &__anonymous {
    padding: 5px 10px;
    font-size: 20px;
    color: rgba(255, 255, 255, 0.75);
  }
}
</style>

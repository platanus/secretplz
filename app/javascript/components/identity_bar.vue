<template>
  <div class="identity-bar">
    <div v-if="idKey">
      {{ idKey }}
    </div>
    <div v-else>
      Anonymous
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
}
</style>

<template>
  <div class="simple-secret-display">
    <div>This secret is sealed!</div>

    <div>Enter a private key as HEX value</div>
    <input type="text" v-model="privateKey"/>

    <div>
      <div>The decoded secret is:</div>
      <div>{{ decodedSecret }}</div>
    </div>
  </div>
</template>

<script>
import ecies from '../services/simple_ecies';

export default {
  data: () => ({
    privateKey: '',
    decodedSecret: '',
  }),
  props: ['encryptedSecret'],
  watch: {
    privateKey(_value) {
      this.decodedSecret = '';
      this.decodedSecret = ecies.decrypt(_value, this.encryptedSecret);
    },
  },
};
</script>

<style>
.simple-secret-display {

}
</style>

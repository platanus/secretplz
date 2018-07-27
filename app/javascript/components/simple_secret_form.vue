<template>
  <div class="simple-secret-form">
    <form @submit="submit($event)" method="POST">
      <label>Enter a secret</label>
      <input type="secret" v-model="secretValue"/>
      <input type="hidden" name="_method" value="PUT"/>
      <input type="hidden" ref="encryptedInput" name="encrypted_data"/>

      <button type="submit" :disabled="secretValue.length === 0">Submit</button>
    </form>
    Public key: {{ publicKey }}
  </div>
</template>

<script>
import ecies from '../services/simple_ecies';

export default {
  data: () => ({
    secretValue: '',
    encryptedValue: '',
    canSubmit: false,
  }),
  props: ['publicKey'],
  methods: {
    submit(_event) {
      if (this.secretValue.length > 0) {
        this.$refs.encryptedInput.value = ecies.encrypt(this.publicKey, this.secretValue);
      } else {
        _event.preventDefault();
      }
    },
  },
};
</script>

<style>
.simple-secret-form {

}
</style>

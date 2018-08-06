<template>
  <div class="simple-secret-form">
    <form @submit="submit($event)" method="POST">
      <div class="simple-secret-form__section">
        <div class="simple-secret-form__section-header">
          Enter a secret
        </div>
        <div class="simple-secret-form__section-content">
          <input type="password" v-model="secretValue"/>
          <input type="hidden" name="_method" value="PUT"/>
          <input type="hidden" ref="encryptedInput" name="encrypted_data"/>

          <button type="submit" :disabled="secretValue.length === 0">Submit</button>
        </div>
      </div>
    </form>
    <div class="simple-secret-form__section">
      <div class="simple-secret-form__section-header">
        Public key
      </div>
      <div class="simple-secret-form__section-content">
        <div class="simple-secret-form__public-key">
          {{ publicKey }}
        </div>
      </div>
    </div>
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

<style lang="scss">
.simple-secret-form {
  max-width: 200px;
  border: 1px solid #e5e5e5;
  background: white;
  padding: 50px;

  &__section {
    margin-bottom: 10px;
  }

  &__section-header {
    display: block;
    font-size: 20px;
  }

  &__section-content {
    display: block;

    input {
      border: none;
      border-radius: 0;
      border-bottom: 1px solid black;
      background: #EFEFEF;
      height: 20px;
    }

    button {
      border-radius: 4px;
      font-size: 13px;
      background: #6da584;
      color: white;
      padding: 5px 10px;
    }
  }

  &__public-key {
    font-size: 10px;
    overflow: hidden;
    overflow-wrap: break-word;
  }
}
</style>

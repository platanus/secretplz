<template>
  <div class="simple-secret-form" v-if="secret">
    <div class="simple-secret-form__content">
      <div class="simple-secret-form__message">
        <span v-if="secret.message">{{ secret.message }}</span>
        <span v-else>tell me the secret</span>
      </div>

      <div class="simple-secret-form__response">
        <form @submit="submit($event)" method="POST" :action="`/sh/${secret.id}`">
          <input type="password" v-model="secretValue"/>
          <input type="hidden" name="_method" value="PUT"/>
          <input type="hidden" ref="encryptedInput" name="encrypted_data"/>

          <button type="submit" :disabled="secretValue.length === 0">Send</button>
        </form>
      </div>
    </div>

    <div class="simple-secret-form__footer">
      publickey: {{ secret.publicKey }}

      <span v-if="secret.signature">
        sigpayload: {{ secret.publicKey }}
        signature: {{ secret.signature }}
      </span>
    </div>
  </div>
</template>

<script>
import ecies from '../services/simple_ecies';
import api from '../services/api';

export default {
  data: () => ({
    secret: null,
    secretValue: '',
    encryptedValue: '',
    canSubmit: false,
  }),
  methods: {
    submit(_event) {
      if (this.secretValue.length > 0) {
        this.$refs.encryptedInput.value = ecies.encrypt(this.secret.publicKey, this.secretValue);
      } else {
        _event.preventDefault();
      }
    },
  },
  async created () {
    const secretId = window.location.hash.replace('#', '');
    this.secret = await api.getSimpleSecret(secretId);
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

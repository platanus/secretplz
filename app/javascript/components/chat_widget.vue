<template>
  <div class="chat-widget" v-if="secret">
    <div class="chat-widget__header">
      <identity-bar :secret="secret"></identity-bar>
    </div>

    <div class="chat-widget__content">
      <div class="chat-widget__message">
        <span v-if="secret.message">{{ secret.message }}</span>
        <span v-else>tell me the secret</span>
      </div>

      <div class="chat-widget__response">
        <form @submit="submit($event)" method="POST" :action="`/sh/${secret.id}`">
          <input type="password" v-model="secretValue"/>
          <input type="hidden" name="_method" value="PUT"/>
          <input type="hidden" ref="encryptedInput" name="encrypted_data"/>

          <button type="submit" :disabled="secretValue.length === 0">Send</button>
        </form>
      </div>
    </div>

    <div class="chat-widget__footer">
      <disclaimer-bar :secret="secret"></disclaimer-bar>
    </div>
  </div>
</template>

<script>
import ecies from '../services/simple_ecies';
import api from '../services/api';

import IdentityBar from './identity_bar.vue';
import DisclaimerBar from './disclaimer_bar.vue';

export default {
  data: () => ({
    secret: null,
    secretValue: '',
    encryptedValue: '',
    canSubmit: false,
  }),
  components: {
    'identity-bar': IdentityBar,
    'disclaimer-bar': DisclaimerBar,
  },
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
.chat-widget {
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

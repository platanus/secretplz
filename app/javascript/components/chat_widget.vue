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
          <input type="password" v-model="secretValue" autofocus=""/>
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
  background: white;
  border: 3px solid #186573;
  padding: 0;
  margin: 0;

  &__header {

  }

  &__content {
    display: flex;
    flex-direction: column;
    background: beige;
    padding: 10px 15px;
    min-height: 300px;
  }

  &__message {
    display: block;
    position: relative;
    align-self: flex-start;
    width: 300px;
    background: lightgreen;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 2px;
    box-shadow: -1px -1px 3px rgba(0, 0, 0, 0.2);
  }

  &__message:after {
    content: '';
    position: absolute;
    left: -10px;
    top: 3px;
    width: 0;
    height: 0;
    border: 10px solid transparent;
    border-right-color: lightgreen;
    border-left: 0;
    border-top: 0;
    box-shadow: 0px -1px rgba(0, 0, 0, 0.2);
  }

  &__response {
    display: block;
    position: relative;
    align-self: flex-end;
    width: 300px;
    background: white;
    padding: 10px;
    border-radius: 2px;
    box-shadow: 1px -1px 3px rgba(0, 0, 0, 0.2);

    input {
      display: block;
      border: none;
      height: 20px;
      width: 80%;
    }

    button {
      border-radius: 4px;
      font-size: 13px;
      background: #AAA;
      color: white;
      padding: 5px 10px;
      float: right;

      &:disabled {
        background: #CCC;
      }
    }
  }

  &__response:after {
    content: '';
    position: absolute;
    right: -10px;
    top: 3px;
    width: 0;
    height: 0;
    border: 10px solid transparent;
    border-left-color: white;
    border-right: 0;
    border-top: 0;
    box-shadow: 0px -1px rgba(0, 0, 0, 0.2);
  }
}
</style>

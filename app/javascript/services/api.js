/* eslint-disable dot-notation */

import axios from 'axios';

export default {
  async getSimpleSecret(_id) {
    const response = await axios.get(`/sh/${_id}.json`);

    return {
      id: response.data['secret']['id'],
      publicKey: response.data['secret']['public_key'],
      message: response.data['secret']['message'],
      signature: response.data['secret']['signature'],
      sealed: (response.data['secret']['sealed_at'] !== null),
    };
  },
};

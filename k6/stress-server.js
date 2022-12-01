import http from 'k6/http';

import { sleep } from 'k6';

export const options = {
  discardResponseBodies: true,

  scenarios: {
    contacts: {
      executor: "constant-vus",

      vus: 1500,

      duration: "120s",
    },
  },
};

const params = {
  headers: {
    "Content-Type": "application/json",
  },
};

export default function () {
    const randomPostId = Math.floor(Math.random() * 60000);
    const randomGetId = Math.floor(Math.random() * 60000);

    const payload = JSON.stringify({
        id: randomPostId,
        name: "Harold",
        age: 5
    });

    http.post("http://167.172.164.237:1337/cats", payload, params);
    http.get(`http://167.172.164.237:1337/cats/${randomGetId}`);
}
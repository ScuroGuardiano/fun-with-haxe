import http from 'k6/http';

import { sleep } from 'k6';

export const options = {
  discardResponseBodies: true,

  scenarios: {
    contacts: {
      executor: "ramping-vus",

      startVUs: 0,

      stages: [
        { duration: "20s", target: 100 },
        { duration: "20s", target: 200 },
        { duration: "20s", target: 350 },
        { duration: "20s", target: 500 },
        { duration: "20s", target: 1000 },
        { duration: "20s", target: 1000 },
        { duration: "30s", target: 0 }
      ],

      gracefulRampDown: "0s",
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
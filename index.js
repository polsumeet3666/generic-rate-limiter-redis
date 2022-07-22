require('dotenv').config();

const Redis = require("ioredis");
const redis = new Redis();

const HASH = process.env.HASH;
const SLIDING_WINDOW = process.env.SLIDING_WINDOW;
const MAX_REQUEST = process.env.MAX_REQUEST;
const NO_KEYS = process.env.NO_KEYS;
const REDIS_KEY = process.env.REDIS_KEY;

(async () => {
  let r = await redis.evalsha(HASH, NO_KEYS, SLIDING_WINDOW, REDIS_KEY, MAX_REQUEST);
  console.log("🚀 ~ file: index.js ~ line 67 ~ r", r);

  let hits = [];
  // create 5 hits
  for (let i = 0; i < 5; i++) {
    hits.push(redis.evalsha(HASH, NO_KEYS, SLIDING_WINDOW, REDIS_KEY, MAX_REQUEST));
  }
  // fire all hits at once
  Promise.all(hits).then((result) => {
    console.log(result);
  });
})();

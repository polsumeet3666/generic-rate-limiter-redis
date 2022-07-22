## Generic Rate Limiter using redis and lua scripting

### Requirement
> want to create sliding window rate limiter which can be used for any TPS control

### Solution
 whenever script is invoke, it will assume current invoke time as time of hit/request
for script we pass 3 arguments 
* arg1: sliding window duration in seconds number
* arg2: redis key string
* arg3: max request number
 

#### flow of script
1. capture current time from redis server
2. remove all the hit timestamps from sorted set 
3. fetch size of sorted set
4. conditional logic if size of set is less than max, then add current time stamp in sorted set and set window duration as expiry and return 0
5. if size of set is more than max, then return 1 
 

### Tech Stack
* NodeJS
* Lua script
* Redis using docker
* node library ioredis
* node library dotenv

### Useful commands
start redis server using docker
```
docker run -d --name some-redis -p 6379:6379 redis
```
command to start redis cli
```
docker exec -it some-redis redis-cli
```

command to copy lua script in docker container
```
docker cp rate-limiter.lua <container_id>:/data/rate-limiter.lua
```

command to start bash in container
```
docker exec -it some-redis bash
```

command to load lua script in redis, once inside bash
```
redis-cli -x script load < rate-limiter.lua
```

command to run
```
node index.js
```
above command will return ```SHA1``` hash of lua script 

### References
* https://developer.redis.com/develop/dotnet/aspnetcore/rate-limiting/sliding-window/
* https://redis.io/docs/manual/transactions/
* https://engagor.github.io/blog/2017/05/02/sliding-window-rate-limiter-redis/
* https://www.ibm.com/cloud/blog/a-quick-guide-to-redis-lua-scripting
* https://redis.io/docs/manual/programmability/eval-intro/
* https://luin.github.io/ioredis/classes/Redis.html
* https://stackoverflow.com/questions/45405693/redis-load-lua-script-and-cache-it-from-file-instead-of-script-load
* https://stackoverflow.com/questions/22907231/how-to-copy-files-from-host-to-docker-container#31971697
* https://www.npmjs.com/package/ioredis
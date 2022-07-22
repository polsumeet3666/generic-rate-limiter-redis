-- first arg sliding window duration in seconds
local window = ARGV[1]
-- second arg name of sorted set (key name)
local key = ARGV[2]
-- thrid arg max request allowed (max tps allowed)
local max_requests = ARGV[3]
-- picks current time of invocation as current time
local current_time = redis.call('TIME')
local trim_time = tonumber(current_time[1]) - window
-- remove all the hit timestamp which are before current timestamp
redis.call('ZREMRANGEBYSCORE', key, 0, trim_time)
-- fetch the size of sorted set
local request_count = redis.call('ZCARD',key)
-- conditional logic
if request_count < tonumber(max_requests) then
    -- if hit is withing limit, then add current time stamp in sorted set
    redis.call('ZADD', key, current_time[1], current_time[1] .. current_time[2])
    -- add ttl for sliding window
    redis.call('EXPIRE', key, window)
    -- return 0 for sucess (current hit is allowed)
    return 0
end
-- return 1 for failure (current hit is not allowed)
return 1




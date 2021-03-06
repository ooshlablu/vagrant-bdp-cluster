#! /bin/bash
function vagrant_name () {
    local NODE_NUMBER=$1
    VAGRANT_NAME="riak$NODE_NUMBER"
}   
function vagrant_names () {
    local NODE_COUNT=$1
    local VAGRANT_NAMES_=""
    for NODE_NUMBER in $(seq 1 $NODE_COUNT); do
        vagrant_name $NODE_NUMBER
        VAGRANT_NAMES_="$VAGRANT_NAMES_ $VAGRANT_NAME"
    done
    VAGRANT_NAMES=${VAGRANT_NAMES_:1}
}
function vagrant_base_ip () {
    VAGRANT_BASE_IP=${VAGRANT_BASE_IP:-"192.168.50"}
}
function vagrant_ip () {
    local NODE_NUMBER=$1
    let NODE_NUMBER+=1
    vagrant_base_ip
    VAGRANT_IP="$VAGRANT_BASE_IP.$NODE_NUMBER"
}           
function vagrant_ips () {
    local NODE_COUNT=$1
    local PORT=$2
    local DELIMITER=${3:-' '}
    if [[ $PORT != "" ]]; then
        PORT=":$PORT"
    fi
    local VAGRANT_IPS_=""
    for NODE_NUMBER in $(seq 1 $NODE_COUNT); do
        vagrant_ip $NODE_NUMBER
        VAGRANT_IPS_="$VAGRANT_IPS_$DELIMITER$VAGRANT_IP$PORT"
    done
    VAGRANT_IPS=${VAGRANT_IPS_:1}
}
function riak_node_name () {
    local NODE_NUMBER=$1
    vagrant_ip $NODE_NUMBER
    RIAK_NODE_NAME="riak_bdp_$NODE_NUMBER@$VAGRANT_IP"
}
function riak_pb_port () {
    RIAK_PB_PORT=${RIAK_PB_PORT:-8097}
}
function riak_http_port () {
    RIAK_HTTP_PORT=${RIAK_HTTP_PORT:-8098}
}
function riak_leader_election_port () {
    RIAK_LEADER_ELECTION_PORT=${RIAK_LEADER_ELECTION_PORT:-5323}
}
function spark_master_port () {
    SPARK_MASTER_PORT=${SPARK_MASTER_PORT:-7777}
}
function redis_port () {
    REDIS_PORT=${REDIS_PORT:-6379}
}
function cache_proxy_port () {
    CACHE_PROXY_PORT=${CACHE_PROXY_PORT:-11211}
}
function cache_proxy_stats_port () {
    CACHE_PROXY_STATS_PORT=${CACHE_PROXY_STATS_PORT:-22223}
}
function cache_ttl () {
    CACHE_TTL=${CACHE_TTL:-"15s"}
}


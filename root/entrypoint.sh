#!/bin/bash

function start_ccm {
    ccm start 
    if [[ $? != 0 ]]; then
        sleep 5s
        start_ccm
    fi
}

start_ccm
